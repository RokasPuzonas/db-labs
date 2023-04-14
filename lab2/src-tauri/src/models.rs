use serde::{Serialize, Deserialize};
use sqlx::FromRow;

pub type Id = u64;

#[derive(Debug, Serialize, FromRow)]
pub struct Manager {
	pub id: Id,
	pub first_name: String,
	pub surname: String,
	pub phone_number: Option<String>,
	pub title: String,
	pub email: Option<String>
}

#[derive(Debug, Deserialize)]
pub struct ManagerData {
	pub first_name: String,
	pub surname: String,
	pub phone_number: Option<String>,
	pub title: String,
	pub email: Option<String>
}

#[derive(Debug, Serialize, FromRow)]
pub struct Factory {
	pub id: Id,
	pub name: String,
	pub location: String,
	pub floor_size: f32,
	pub manager_id: Id
}

#[derive(Debug, Deserialize)]
pub struct FactoryData {
	pub name: String,
	pub location: String,
	pub floor_size: f32
}