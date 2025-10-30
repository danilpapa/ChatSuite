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
        let host_email = env::var("HOST_EMAIL").expect("Host email not set");

        match self {
            EmailProcessor::ConfirmEmail => {
                let email = Message::builder()
                    .from(host_email.parse().unwrap())
                    .to(to.parse().unwrap())
                    .subject(subject)
                    .body(String::from("This is a test email!"))
                    .unwrap();

                let creads = Credentials::new(
                    host_email.clone(), 
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