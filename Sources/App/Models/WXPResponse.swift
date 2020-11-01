import Vapor
import WeatherProvider

//public struct WXPForecastResponse: Content {
//    public var source: String
//    public var updatedAt: Date
//    public var validTimes: DateInterval
//    public var elevation: Measurement<UnitLength>
//    public var periods: [WXPForecastPeriodResponse]
//
//    public init<ForecastType: WXPForecast>(_ forecast: ForecastType) {
//        self.updatedAt = forecast.updatedAt
//        self.validTimes = forecast.validTimes
//        self.elevation = forecast.elevation
//        self.periods = forecast.wxpPeriods.map { WXPForecastPeriodResponse($0) }
//    }
//}

struct WXPForecastPeriodResponse: Content/*, ResponseEncodable*/ {
//    let source: String
    let applicableTime: DateInterval
    let temperature: Measurement<UnitTemperature>
    let wind: WXPWindResponse?

    let condition: WXPCondition?

    let forecast: String?
    let detailedForecast: String?

    init(_ period: WXPForecastPeriod) {
        self.applicableTime = period.applicableTime
        self.temperature = period.temperature
        self.condition = period.wxpCondition
        self.forecast = period.forecast
        self.detailedForecast = period.detailedForecast

        if let wind = period.wxpWind {
            self.wind = WXPWindResponse(wind)
        } else {
            self.wind = nil
        }
    }
}

struct WXPWindResponse: Content {
    let lowSpeed: Measurement<UnitSpeed>
    let highSpeed: Measurement<UnitSpeed>

    let direction: WXPWindDirection

    init(_ wind: WXPWind) {
        switch wind {
        case .range(let low, let high, let direction):
            self.lowSpeed = low
            self.highSpeed = high
            self.direction = direction
        case .single(let speed, let direction):
            self.lowSpeed = speed
            self.highSpeed = speed
            self.direction = direction
        }
    }
}

extension WXPWindDirection: Content { }
extension WXPCondition: Content { }
