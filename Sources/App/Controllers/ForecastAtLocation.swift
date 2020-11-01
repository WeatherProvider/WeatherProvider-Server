import Vapor
import Fluent
import GeohashKit
import WeatherProvider

enum ConditionsAtLocationMethod {
    case coordinates(Double, Double)
    case geohash(Geohash)

    var coordinates: Coordinates {
        switch self {
        case .coordinates(let lat, let lon):
            return Coordinates(lat, lon)
        case .geohash(let hash):
            let coors = hash.coordinates
            return Coordinates(coors.latitude, coors.longitude)
        }
    }
}

func conditionsAtLocation(_ request: Request) throws -> EventLoopFuture<WXPForecastPeriodResponse> {
    let method: ConditionsAtLocationMethod

    if let latitude = try? request.query.get(Double.self, at: "latitude"),
       let longitude = try? request.query.get(Double.self, at: "longitude") {
        method = .coordinates(latitude, longitude)
    } else if let geohashHash = try? request.query.get(String.self, at: "geohash") {
        guard let geohash = Geohash(geohash: geohashHash) else { throw Abort(.internalServerError) }
        method = .geohash(geohash)
    } else {
        throw Abort(.internalServerError)
    }

    let promise = request.eventLoop.makePromise(of: WXPForecastPeriodResponse.self)

    WeatherProvider().getCurrentConditions(for: method.coordinates) { result in
        switch result {
        case .failure(let error):
            promise.fail(error)
        case .success(let period):
            promise.succeed(WXPForecastPeriodResponse(period))
        }
    }

    return promise.futureResult
}
