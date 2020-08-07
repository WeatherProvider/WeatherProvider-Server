import App
import Vapor
import Fluent
import FluentMongoDriver

guard let mongoDBURI = ProcessInfo.processInfo.environment["MONGO_DB_URI"] else {
    fatalError("Missing ENV \"MONGO_DB_URI\"")
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.databases.use(.mongo(connectionString: mongoDBURI), as: .mongo)
try app.run()
