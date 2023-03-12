// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::{env, process::exit};
use dotenv::dotenv;

use serde::{Serialize, Deserialize};
use sqlx::{SqlitePool, sqlite::SqlitePoolOptions, Pool, Sqlite};
use tauri::State;

struct Manager {
	id: i64,
	first_name: String,
	surname: String,
	phone_number: Option<String>,
	title: String,
	email: Option<String>
}

struct Database {
	pool: Pool<Sqlite>
}

#[derive(Serialize, Deserialize)]
enum AddResponse {
	Success(i64)
}

#[tauri::command]
async fn add_manager(
		first_name: &str,
		surname: &str,
		phone_number: Option<&str>,
		title: &str,
		email: Option<&str>,
		database: State<'_, Database>
	) -> Result<AddResponse, ()> {
	let id = sqlx::query_as!(
			Manager,
			r#"
			INSERT INTO manager
				(`FIRST_NAME`, `SURNAME`, `PHONE_NUMBER`, `TITLE`, `EMAIL`)
			VALUES
				(?, ?, ?, ?, ?)
			"#,
			first_name,
			surname,
			phone_number,
			title,
			email
		).execute(&database.pool)
		.await.map_err(|_| ())?
		.last_insert_rowid();

	Ok(AddResponse::Success(id))
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
			add_manager
		])
		.run(tauri::generate_context!())
		.expect("error while running tauri application");
}
