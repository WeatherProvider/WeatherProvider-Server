import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It still works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("conditions_at_location", use: conditionsAtLocation)
}
