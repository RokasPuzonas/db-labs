use anyhow::Result;
use sqlx::{Transaction, MySql};

use crate::models::{ProcessData, Id, Process};

type MySqlTransaction<'a> = Transaction<'a, MySql>;

pub async fn create_table(tx: &mut MySqlTransaction<'_>) -> Result<()> {
    sqlx::query(r#"
        CREATE TABLE IF NOT EXISTS `process` (
            ID   bigint unsigned NOT NULL AUTO_INCREMENT,
            NAME varchar(255)    NOT NULL,
            SIZE float           NOT NULL,

            PRIMARY KEY(ID)
        );"#)
        .execute(&mut *tx).await?;

    Ok(())
}

pub async fn add(tx: &mut MySqlTransaction<'_>, process: &ProcessData) -> Result<Id>
{
    let id = sqlx::query(r#"
		INSERT INTO `process`
			(`NAME`, `SIZE`)
		VALUES
			(?, ?)
        "#)
        .bind(&process.name)
        .bind(process.size)
        .execute(&mut *tx).await?
        .last_insert_id();

	Ok(id)
}

pub async fn list(tx: &mut MySqlTransaction<'_>) -> Result<Vec<Process>> {
	let factories = sqlx::query_as::<_, Process>(
		r#"
		SELECT
            ID   as id,
            NAME as name,
            SIZE as size
        FROM `process`
		"#).fetch_all(tx).await?;

    Ok(factories)
}

pub async fn delete(tx: &mut MySqlTransaction<'_>, id: Id) -> Result<()> {
    sqlx::query("DELETE FROM `process` WHERE ID = ?")
        .bind(id)
        .execute(&mut *tx).await?;

    sqlx::query("DELETE FROM `factory_supports_processes` WHERE FK_PROCESS_ID = ?")
        .bind(id)
        .execute(&mut *tx).await?;

	Ok(())
}

pub async fn update(tx: &mut MySqlTransaction<'_>, id: Id, process: &ProcessData) -> Result<()> {
    sqlx::query(
		r#"
		UPDATE `process` SET
            NAME = ?,
            SIZE = ?
        WHERE ID = ?
		"#)
        .bind(&process.name)
        .bind(process.size)
        .bind(id)
        .execute(tx).await?;

	Ok(())
}