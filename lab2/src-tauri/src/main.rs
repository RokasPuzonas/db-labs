// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod models;
mod factory_repo;
mod manager_repo;
mod api;

use std::{env, process::exit};
use dotenv::dotenv;

use models::{ManagerData, FactoryData};
use sqlx::{Pool, MySql, mysql::MySqlPoolOptions, Row};

use api::*;
use anyhow::Result;

async fn setup_tables(pool: &Pool<MySql>) -> Result<()> {
	let mut tx = pool.begin().await?;
	manager_repo::create_table(&mut tx).await?;
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

async fn enable_foreign_key_checks(pool: &Pool<MySql>) -> Result<()> {
	sqlx::query("SET GLOBAL FOREIGN_KEY_CHECKS=1").execute(pool).await?;
	Ok(())
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
		location: "idk".into(),
		floor_size: 10.0,
	};
	let id = manager_repo::add(&mut tx, &manager).await?;
	factory_repo::add(&mut tx, id, &factory).await?;

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

	enable_foreign_key_checks(&pool).await.expect("Enable foreign key checks");
	drop_all_tables(&pool).await.unwrap(); // For testing purposes
	setup_tables(&pool).await.expect("Setup tables");

	add_test_data(&pool).await.expect("Add test data");

	tauri::Builder::default()
		.manage(Database { pool })
		.invoke_handler(tauri::generate_handler![
			list_factories,
			list_managers,
			add_manager_factory,
			delete_factory,
			update_factory,
			update_manager
		])
		.run(tauri::generate_context!())
		.expect("error while running tauri application");
}
