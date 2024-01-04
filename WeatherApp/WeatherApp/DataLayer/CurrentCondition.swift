import Foundation

struct CurrentCondition: Decodable {
    let weatherText: String
    let temperature: Temperature
    let isDayTime: Bool

    enum CodingKeys: String, CodingKey {
        case weatherText = "WeatherText"
        case temperature = "Temperature"
        case isDayTime = "IsDayTime"
    }
}

struct Temperature: Decodable {
    let metric, imperial: Imperial

    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
}

struct Imperial: Decodable {
    let value: Double
    let unit: String
    let unitType: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}
