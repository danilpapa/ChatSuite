mod email_req;
mod email_processor;

use email_req::EmailRequest;
use email_processor::EmailProcessor;
use actix_web::{post, web, App, HttpResponse, HttpServer, Responder};
use crate::email_processor::IProcessor;

#[post("/send-email")]
async fn send_email(email: web::Json<EmailRequest>) -> impl Responder {
    let email_processor = EmailProcessor::ConfirmEmail;
    email_processor.process_email(&email.to, &email.subject).await;
    println!("Sending email to: {}", email.to);
    return HttpResponse::Ok().body("Email request received");
}

#[actix_web::main]
async fn main() -> Result<(), std::io::Error> {
    HttpServer::new(|| { 
        App::new().service(send_email) 
    })
    .bind("127.0.0.1:8081")?
    .run()
    .await
}
