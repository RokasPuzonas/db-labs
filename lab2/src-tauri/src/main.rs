// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::{env, process::exit};
use dotenv::dotenv;

use serde::{Serialize, Deserialize};
use sqlx::{SqlitePool, sqlite::SqlitePoolOptions, Pool, Sqlite, Row};
use tauri::State;

// TODO: use transaction to revert changes, if failed to insert rows

type Id = i64;

#[derive(Serialize)]
struct Manager {
	id: Id,
	first_name: String,
	surname: String,
	phone_number: Option<String>,
	title: String,
	email: Option<String>
}

#[derive(Deserialize)]
struct ManagerData {
	first_name: String,
	surname: String,
	phone_number: Option<String>,
	title: String,
	email: Option<String>
}

#[derive(Serialize)]
struct Factory {
	id: Id,
	name: String,
	location: String,
	floor_size: f64,
	manager_id: Id
}
#[derive(Deserialize)]
struct FactoryData {
	name: String,
	location: String,
	floor_size: f64
}

struct Database {
	pool: Pool<Sqlite>
}

struct EntryID {
	id: Id
}

async fn add_manager(db: &Database, manager: &ManagerData) -> anyhow::Result<Id> {
	let entry = sqlx::query_as!(
		EntryID,
		r#"
		INSERT INTO manager
			(`FIRST_NAME`, `SURNAME`, `PHONE_NUMBER`, `TITLE`, `EMAIL`)
		VALUES
			(?, ?, ?, ?, ?)
		RETURNING ID as id
		"#,
		manager.first_name,
		manager.surname,
		manager.phone_number,
		manager.title,
		manager.email
	).fetch_one(&db.pool).await?;
	Ok(entry.id)
}

async fn add_factory(db: &Database, manager_id: Id, factory: &FactoryData) -> anyhow::Result<Id> {
	let entry = sqlx::query_as!(
		EntryID,
		r#"
		INSERT INTO factory
			(`NAME`, `LOCATION`, `FLOOR_SIZE`, `FK_MANAGER_ID`)
		VALUES
			(?, ?, ?, ?)
		RETURNING ID as id
		"#,
		factory.name,
		factory.location,
		factory.floor_size,
		manager_id
	).fetch_one(&db.pool).await?;
	Ok(entry.id)
}

async fn list_factories_db(db: &Database) -> anyhow::Result<Vec<Factory>> {
	let factories = sqlx::query_as!(
		Factory,
		r#"
		SELECT ID as id, NAME as name, LOCATION as location, FLOOR_SIZE as floor_size, FK_MANAGER_ID as manager_id FROM factory
		"#,
	).fetch_all(&db.pool).await?;
	Ok(factories)
}

async fn list_managers_db(db: &Database) -> anyhow::Result<Vec<Manager>> {
	let managers = sqlx::query_as!(
		Manager,
		r#"
		SELECT ID as id, FIRST_NAME as first_name, SURNAME as surname, TITLE as title, EMAIL as email, PHONE_NUMBER as phone_number FROM manager
		"#,
	).fetch_all(&db.pool).await?;
	Ok(managers)
}

#[tauri::command]
async fn add_manager_factory(
		factory: FactoryData,
		manager: ManagerData,
		db: State<'_, Database>
	) -> Result<(Id, Id), ()> {
	let manager_id = add_manager(&db, &manager).await.unwrap();
	let factory_id = add_factory(&db, manager_id, &factory).await.unwrap();
	Ok((factory_id, manager_id))
}

#[tauri::command]
async fn list_managers(db: State<'_, Database>) -> Result<Vec<Manager>, ()> {
	Ok(list_managers_db(&db).await.unwrap()) // TODO: handle .unwrap()
}

#[tauri::command]
async fn list_factories(db: State<'_, Database>) -> Result<Vec<Factory>, ()> {
	Ok(list_factories_db(&db).await.unwrap()) // TODO: handle .unwrap()
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

	let pool = SqlitePoolOptions::new()
		.max_connections(10)
		.connect(&database_url)
		.await
		.unwrap();

	tauri::Builder::default()
		.manage(Database { pool })
		.invoke_handler(tauri::generate_handler![
			list_factories,
			list_managers,
			add_manager_factory
		])
		.run(tauri::generate_context!())
		.expect("error while running tauri application");
}
