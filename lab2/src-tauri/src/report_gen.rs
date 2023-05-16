use anyhow::Result;
use serde::Serialize;
use sqlx::{Transaction, MySql, FromRow};

use crate::models::{Id, ProcessData};

type MySqlTransaction<'a> = Transaction<'a, MySql>;

#[derive(Debug, Serialize, FromRow)]
pub struct FactoryUsedSpace {
    manager_name: String,
    factory_id: Id,
    used_size: f32,
    used_percent: f32
}

pub async fn get_factories_by_used_space(tx: &mut MySqlTransaction<'_>, from: f32, to: f32, location: &str) -> Result<Vec<FactoryUsedSpace>> {
    let results = sqlx::query_as::<_, FactoryUsedSpace>(r#"
        SELECT
            CONCAT(manager.FIRST_NAME, " ", manager.SURNAME) as manager_name,
            factory.ID as factory_id,
            SUM(process.SIZE) as used_size,
            ROUND(CAST(SUM(process.SIZE) as FLOAT) / CAST(factory.FLOOR_SIZE as FLOAT) * 100, 2) as used_percent
        FROM
            factory
        LEFT JOIN factory_supports_processes
            ON factory_supports_processes.FK_FACTORY_ID = factory.ID
        LEFT JOIN process
            ON process.ID = factory_supports_processes.FK_PROCESS_ID
        LEFT JOIN manager
            ON manager.ID = factory.FK_MANAGER_ID
        WHERE LOCATE(?, factory.LOCATION)>0
        GROUP BY factory.ID
        HAVING ? <= used_percent AND used_percent <= ?
        "#)
        .bind(location)
        .bind(from)
        .bind(to)
        .fetch_all(tx).await?;

    Ok(results)
}

pub async fn get_processess_of_factory(tx: &mut MySqlTransaction<'_>, factory_id: Id) -> Result<Vec<ProcessData>> {
    let results = sqlx::query_as::<_, ProcessData>("
        SELECT
            process.NAME as name,
            process.SIZE as size
        FROM
            factory
        LEFT JOIN factory_supports_processes
            ON factory_supports_processes.FK_FACTORY_ID = factory.ID
        LEFT JOIN process
            ON process.ID = factory_supports_processes.FK_PROCESS_ID
        WHERE factory.ID = 1
        ")
        .bind(factory_id)
        .fetch_all(tx).await?;

    Ok(results)
}