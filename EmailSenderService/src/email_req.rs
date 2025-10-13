use serde::Deserialize;

#[derive(Deserialize)]
pub struct EmailRequest {
    pub to: String, 
    pub subject: String
}