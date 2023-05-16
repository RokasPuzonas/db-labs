use crate::{models::{Manager, Factory, ManagerData, FactoryData, Id, Process, ProcessData}, manager_repo, factory_repo, process_repo, report_gen::{self, FactoryUsedSpace}};
use sqlx::{Pool, MySql};
use tauri::State;
use anyhow::Result;

pub struct Database {
	pub pool: Pool<MySql>
}

#[tauri::command]
pub async fn add_manager_factory(
	factory: FactoryData,
	manager: ManagerData,
	db: State<'_, Database>
) -> Result<(Id, Id)> {
	let mut tx = db.pool.begin().await?;
	let manager_id = manager_repo::add(&mut tx, &manager).await?;
	let factory_id = factory_repo::add(&mut tx, manager_id, &factory).await?;
	tx.commit().await?;
	Ok((factory_id, manager_id))
}

// --------------------- Factory ---------------------------

#[tauri::command]
pub async fn list_factories(db: State<'_, Database>) -> Result<Vec<Factory>> {
	let mut tx = db.pool.begin().await?;
	let factories = factory_repo::list(&mut tx).await?;
	tx.commit().await?;
	Ok(factories)
}

#[tauri::command]
pub async fn update_factory(id: Id, factory: FactoryData, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	factory_repo::update(&mut tx, id, &factory).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn delete_factory(id: Id, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	factory_repo::delete(&mut tx, id).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn list_factory_processess(id: Id, db: State<'_, Database>) -> Result<Vec<Id>> {
	let mut tx = db.pool.begin().await?;
	let processess = factory_repo::list_processess(&mut tx, id).await?;
	tx.commit().await?;
	Ok(processess)
}

#[tauri::command]
pub async fn add_factory_process(factory_id: Id, process_id: Id, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	factory_repo::add_process(&mut tx, factory_id, process_id).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn delete_factory_process(factory_id: Id, process_id: Id, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	factory_repo::delete_process(&mut tx, factory_id, process_id).await?;
	tx.commit().await?;
	Ok(())
}

// --------------------- Manager ---------------------------

#[tauri::command]
pub async fn list_managers(db: State<'_, Database>) -> Result<Vec<Manager>> {
	let mut tx = db.pool.begin().await?;
	let managers = manager_repo::list(&mut tx).await?;
	tx.commit().await?;
	Ok(managers)
}

#[tauri::command]
pub async fn update_manager(id: Id, manager: ManagerData, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	manager_repo::update(&mut tx, id, &manager).await?;
	tx.commit().await?;
	Ok(())
}


// --------------------- Process ---------------------------

#[tauri::command]
pub async fn list_processess(db: State<'_, Database>) -> Result<Vec<Process>> {
	let mut tx = db.pool.begin().await?;
	let processess = process_repo::list(&mut tx).await?;
	tx.commit().await?;
	Ok(processess)
}

#[tauri::command]
pub async fn delete_process(id: Id, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	process_repo::delete(&mut tx, id).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn update_process(id: Id, process: ProcessData, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	process_repo::update(&mut tx, id, &process).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn add_process(
	process: ProcessData,
	db: State<'_, Database>
) -> Result<Id> {
	let mut tx = db.pool.begin().await?;
	let id = process_repo::add(&mut tx, &process).await?;
	tx.commit().await?;
	Ok(id)
}

// --------------------- Report generation ---------------------------

#[tauri::command]
pub async fn get_factories_by_used_space(
	from: f32,
	to: f32,
	location: String,
	db: State<'_, Database>
) -> Result<Vec<FactoryUsedSpace>> {
	let mut tx = db.pool.begin().await?;
	let results = report_gen::get_factories_by_used_space(&mut tx, from, to, &location).await?;
	tx.commit().await?;
	Ok(results)
}

#[tauri::command]
pub async fn get_processess_of_factory(
	factory: Id,
	db: State<'_, Database>
) -> Result<Vec<ProcessData>> {
	let mut tx = db.pool.begin().await?;
	let results = report_gen::get_processess_of_factory(&mut tx, factory).await?;
	tx.commit().await?;
	Ok(results)
}