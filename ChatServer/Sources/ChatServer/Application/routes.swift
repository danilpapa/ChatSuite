import Fluent
import Vapor

func routes(_ app: Application) throws {

    app.webSocket("chat") { req, ws in
        ws.onText { ws, text in
            print(text)
        }
        
        ws.onClose.whenComplete { _ in
            print("Close")
        }
        
        ws.send("Hello")
    }
}
