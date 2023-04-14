
use anyhow::Result;
use sqlx::{Transaction, MySql};

use crate::models::{ManagerData, Id, Manager};

type MySqlTransaction<'a> = Transaction<'a, MySql>;

pub async fn create_table(tx: &mut MySqlTransaction<'_>) -> Result<()> {
    sqlx::query(r#"
        CREATE TABLE IF NOT EXISTS `manager` (
            ID           bigint unsigned NOT NULL,
            FIRST_NAME   varchar(255)    NOT NULL,
            SURNAME      varchar(255)    NOT NULL,
            PHONE_NUMBER varchar(255)        NULL,
            TITLE        varchar(255)    NOT NULL,
            EMAIL        varchar(255)        NULL,
            PRIMARY KEY(ID)
        );"#)
        .execute(tx).await?;
    Ok(())
}

pub async fn add(tx: &mut MySqlTransaction<'_>, manager: &ManagerData) -> Result<Id>
{
    let id = sqlx::query(r#"
		INSERT INTO `manager`
			(`FIRST_NAME`, `SURNAME`, `PHONE_NUMBER`, `TITLE`, `EMAIL`)
		VALUES
			(?, ?, ?, ?, ?)
        "#)
        .bind(&manager.first_name)
        .bind(&manager.surname)
        .bind(&manager.phone_number)
        .bind(&manager.title)
        .bind(&manager.email)
        .execute(&mut *tx).await?
        .last_insert_id();

	Ok(id)
}

pub async fn list(tx: &mut MySqlTransaction<'_>) -> Result<Vec<Manager>> {
	let managers = sqlx::query_as::<_, Manager>(
		r#"
		SELECT
            ID           as id,
            FIRST_NAME   as first_name,
            SURNAME      as surname,
            TITLE        as title,
            EMAIL        as email,
            PHONE_NUMBER as phone_number
        FROM `manager`
		"#).fetch_all(tx).await?;

	Ok(managers)
}

pub async fn update(tx: &mut MySqlTransaction<'_>, id: Id, manager: &ManagerData) -> Result<()> {
    sqlx::query(
		r#"
		UPDATE `manager` SET
            FIRST_NAME   = ?,
            SURNAME      = ?,
            TITLE        = ?,
            EMAIL        = ?,
            PHONE_NUMBER = ?
        WHERE ID = ?
		"#)
        .bind(&manager.first_name)
        .bind(&manager.surname)
        .bind(&manager.title)
        .bind(&manager.email)
        .bind(&manager.phone_number)
        .bind(id)
        .execute(tx).await?;

	Ok(())
}