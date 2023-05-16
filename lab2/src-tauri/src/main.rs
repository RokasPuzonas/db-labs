// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod models;
mod factory_repo;
mod manager_repo;
mod process_repo;
mod report_gen;
mod api;

use std::{env, process::exit};
use dotenv::dotenv;

use models::{ManagerData, FactoryData, ProcessData, Id};
use sqlx::{Pool, MySql, mysql::MySqlPoolOptions, Row, Transaction};

use api::*;
use anyhow::Result;

type MySqlTransaction<'a> = Transaction<'a, MySql>;

async fn setup_tables(pool: &Pool<MySql>) -> Result<()> {
	let mut tx = pool.begin().await?;
	manager_repo::create_table(&mut tx).await?;
	process_repo::create_table(&mut tx).await?;
	factory_repo::create_table(&mut tx).await?;
	tx.commit().await?;
	Ok(())
}

async fn drop_all_tables(pool: &Pool<MySql>) -> Result<()> {
	let tables = sqlx::query("SHOW TABLES").fetch_all(pool).await?;
	let names: Vec<_> = tables.into_iter().map(|row| row.get::<String, usize>(0)).collect();
	sqlx::query(&format!("DROP TABLE {}", names.join(", ")))
		.execute(pool)
		.await?;

	Ok(())
}

async fn set_foreign_key_checks(pool: &Pool<MySql>, enable: bool) -> Result<()> {
	let query = match enable {
		true => "SET FOREIGN_KEY_CHECKS=1",
		false => "SET FOREIGN_KEY_CHECKS=0",
	};
	sqlx::query(query).execute(pool).await?;
	Ok(())
}

async fn add_test_processess(tx: &mut MySqlTransaction<'_>, processess: &[ProcessData]) -> Result<Vec<Id>> {
	let mut ids = vec![];
	for process in processess {
		let id = process_repo::add(tx, &process).await?;
		ids.push(id);
	}
	Ok(ids)
}

async fn add_test_data(pool: &Pool<MySql>) -> Result<()> {
	let mut tx = pool.begin().await?;
	let manager = ManagerData {
		first_name: "Rokas".into(),
		surname: "Puzonas".into(),
		phone_number: Some("+123456789".into()),
		title: "Big man".into(),
		email: Some("bigman@pp.com".into())
	};
	let factory = FactoryData {
		name: "Big factory".into(),
		location: "Kaunas, fabriko gatve 1".into(),
		floor_size: 10.0,
	};
	let manager_id = manager_repo::add(&mut tx, &manager).await?;
	let factory_id = factory_repo::add(&mut tx, manager_id, &factory).await?;

	let process_ids = add_test_processess(&mut tx, &[
		ProcessData { name: "Certifuge 9000".into(), size: 10.0 },
		ProcessData { name: "Certifuge 9001".into(), size: 20.0 },
		ProcessData { name: "Certifuge 9002".into(), size: 30.0 }
	]).await?;

	factory_repo::add_process(&mut tx, factory_id, process_ids[0]).await?;
	factory_repo::add_process(&mut tx, factory_id, process_ids[1]).await?;

	tx.commit().await?;
	Ok(())
}

#[async_std::main]
async fn main() {
	dotenv().ok();

	let database_url = match env::var("DATABASE_URL") {
		Err(_) => {
			println!("Error: DATABASE_URL not defined");
			exit(1);
		},
		Ok(url) => url,
	};

	let pool = MySqlPoolOptions::new()
		.max_connections(10)
		.connect(&database_url)
		.await
		.unwrap();

	set_foreign_key_checks(&pool, false).await.expect("Disable foreign key checks");
	drop_all_tables(&pool).await.unwrap(); // For testing purposes
	set_foreign_key_checks(&pool, true).await.expect("Enable foreign key checks");
	setup_tables(&pool).await.expect("Setup tables");

	add_test_data(&pool).await.expect("Add test data");

	tauri::Builder::default()
		.manage(Database { pool })
		.invoke_handler(tauri::generate_handler![
			add_manager_factory,

			list_factories,
			delete_factory,
			update_factory,
			list_factory_processess,
			add_factory_process,
			delete_factory_process,

			list_managers,
			update_manager,

			list_processess,
			update_process,
			delete_process,
			add_process,

			get_factories_by_used_space,
			get_processess_of_factory
		])
		.run(tauri::generate_context!())
		.expect("error while running tauri application");
}
