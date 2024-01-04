import Foundation

protocol Networkable {
    func retrieveLocationWeather(key:String) async throws -> [CurrentCondition]
    func retriveAutocompleteText(text: String) async throws -> [LocationModel]
}

class WeatherNetworking: Networkable {
    
    enum NetworkError: Error {
        case invalidURL
        case unavailableData
        case errorParsingData
    }
    
    static let shared = WeatherNetworking()
    private var session: URLSession
    private let urlString = ""
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func retriveAutocompleteText(text: String) async throws -> [LocationModel] {
        guard let url = WeatherEndpoint.EndpointPaths.autocomplete(text: text).url else {
            throw NetworkError.invalidURL
        }
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([LocationModel].self, from: data)
    }

    func retrieveLocationWeather(key:String) async throws -> [CurrentCondition] {
        guard let url = WeatherEndpoint.EndpointPaths.currentConditions(key: key).url else {
            throw NetworkError.invalidURL
        }
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([CurrentCondition].self, from: data)
    }
}
