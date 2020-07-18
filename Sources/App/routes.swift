import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It still works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
