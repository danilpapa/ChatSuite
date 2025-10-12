mod email_req;
use email_req::EmailRequest;

use actix_web::{http::StatusCode, post, web, App, HttpResponse, HttpServer, Responder};


#[post("/send-email")]
async fn send_email(email: web::Json<EmailRequest>) -> impl Responder {
    // web::Json<T> автоматически распарсит тело post
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
