use std::env;
use async_trait::async_trait;
use lettre::{transport::smtp::authentication::Credentials, Message, SmtpTransport, Transport};

pub enum EmailProcessor {
    ConfirmEmail
}

#[async_trait]
pub trait IProcessor {
    async fn process_email(&self, to: &str, subject: &str);
}

#[async_trait]
impl  IProcessor for EmailProcessor {

    async fn process_email(&self, to: &str, subject: &str) {
        match self {
            EmailProcessor::ConfirmEmail => {
                let email = Message::builder()
                    .from("some_email@gmail.com".parse().unwrap())
                    .to(to.parse().unwrap())
                    .subject(subject)
                    .body(String::from("This is a test email!"))
                    .unwrap();

                let creads = Credentials::new(
                    String::from("some_email@gmail.com"), 
                    String::from("App password")
                );
                
                let mailer = SmtpTransport::relay("smth.gmail.com")
                    .unwrap()
                    .credentials(creads)
                    .build();

                match mailer.send(&email) {
                    Ok(_) => println!("success!"),
                    Err(e) => println!("some error :{:?}", e),
                };
            }
        }
    }
}