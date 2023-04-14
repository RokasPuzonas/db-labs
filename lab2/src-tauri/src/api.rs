use crate::{models::{Manager, Factory, ManagerData, FactoryData, Id}, manager_repo, factory_repo};
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

#[tauri::command]
pub async fn delete_factory(id: Id, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	factory_repo::delete(&mut tx, id).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn update_factory(id: Id, factory: FactoryData, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	factory_repo::update(&mut tx, id, &factory).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn update_manager(id: Id, manager: ManagerData, db: State<'_, Database>) -> Result<()> {
	let mut tx = db.pool.begin().await?;
	manager_repo::update(&mut tx, id, &manager).await?;
	tx.commit().await?;
	Ok(())
}

#[tauri::command]
pub async fn list_managers(db: State<'_, Database>) -> Result<Vec<Manager>> {
	let mut tx = db.pool.begin().await?;
	let managers = manager_repo::list(&mut tx).await?;
	tx.commit().await?;
	Ok(managers)
}

#[tauri::command]
pub async fn list_factories(db: State<'_, Database>) -> Result<Vec<Factory>> {
	let mut tx = db.pool.begin().await?;
	let factories = factory_repo::list(&mut tx).await?;
	tx.commit().await?;
	Ok(factories)
}

