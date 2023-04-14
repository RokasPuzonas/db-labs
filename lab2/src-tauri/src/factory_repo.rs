use crate::models::{Id, FactoryData, Factory};
use anyhow::Result;
use sqlx::{Transaction, MySql};

type MySqlTransaction<'a> = Transaction<'a, MySql>;

pub async fn create_table(tx: &mut MySqlTransaction<'_>) -> Result<()> {
    sqlx::query(r#"
        CREATE TABLE IF NOT EXISTS `factory` (
            ID            bigint unsigned NOT NULL,
            NAME          varchar(255)    NOT NULL,
            LOCATION      varchar(255)    NOT NULL,
            FLOOR_SIZE    float           NOT NULL,
            FK_MANAGER_ID bigint unsigned NOT NULL,

            PRIMARY KEY(ID),
            UNIQUE(FK_MANAGER_ID),
            FOREIGN KEY(FK_MANAGER_ID) REFERENCES MANAGER (ID) ON DELETE CASCADE
        );"#).execute(tx).await?;
    Ok(())
}

pub async fn add(tx: &mut MySqlTransaction<'_>, manager_id: Id, factory: &FactoryData) -> Result<Id> {
    let id = sqlx::query(r#"
		INSERT INTO `factory`
			(`NAME`, `LOCATION`, `FLOOR_SIZE`, `FK_MANAGER_ID`)
		VALUES
			(?, ?, ?, ?)
		"#)
		.bind(&factory.name)
		.bind(&factory.location)
		.bind(factory.floor_size)
		.bind(manager_id)
        .execute(&mut *tx).await?
        .last_insert_id();

	Ok(id)
}

pub async fn list(tx: &mut MySqlTransaction<'_>) -> Result<Vec<Factory>> {
	let factories = sqlx::query_as::<_, Factory>(
		r#"
		SELECT
            ID            as id,
            NAME          as name,
            LOCATION      as location,
            FLOOR_SIZE    as floor_size,
            FK_MANAGER_ID as manager_id
        FROM `factory`
		"#).fetch_all(tx).await?;

    Ok(factories)
}

pub async fn delete(tx: &mut MySqlTransaction<'_>, id: Id) -> Result<()> {
	sqlx::query("DELETE FROM `manager` WHERE ID = (SELECT FK_MANAGER_ID FROM `factory` WHERE ID = ?)")
        .bind(id)
        .execute(&mut *tx).await?;

    sqlx::query("DELETE FROM `factory` WHERE ID = ?")
        .bind(id)
        .execute(&mut *tx).await?;

	Ok(())
}

pub async fn update(tx: &mut MySqlTransaction<'_>, id: Id, factory: &FactoryData) -> Result<()> {
    sqlx::query(
		r#"
		UPDATE `factory` SET
            NAME       = ?,
            LOCATION   = ?,
            FLOOR_SIZE = ?
        WHERE ID = ?
		"#)
        .bind(&factory.name)
        .bind(&factory.location)
        .bind(factory.floor_size)
        .bind(id)
        .execute(tx).await?;

	Ok(())
}