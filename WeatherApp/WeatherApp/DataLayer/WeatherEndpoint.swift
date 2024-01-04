import Foundation

struct WeatherEndpoint {

    enum EndpointPaths {
        case autocomplete(text: String)
        case currentConditions(key: String)
        
        var path: String {
            switch self {
            case .autocomplete:
                "/locations/v1/cities/autocomplete"
            case .currentConditions:
                "/currentconditions/v1/"
            }
        }
        
        var url: URL? {
            switch self {
            case .autocomplete(text: let text):
                guard var components = URLComponents(url: WeatherEndpoint().baseURL, resolvingAgainstBaseURL: true) else {
                    return nil
                }
                components.path = path
                components.queryItems = [URLQueryItem(name: "apikey", value: WeatherEndpoint().apiKey), URLQueryItem(name: "q", value: text)]
                return components.url
            case .currentConditions(key: let key):
                guard var components = URLComponents(url: WeatherEndpoint().baseURL, resolvingAgainstBaseURL: true) else {
                    return nil
                }
                components.path = path + key
                components.queryItems = [URLQueryItem(name: "apikey", value: WeatherEndpoint().apiKey)]
                return components.url
            }
        }
        
    }

    let baseURL = URL(string: "https://dataservice.accuweather.com")!
    let apiKey = "H8bCnUh1nKavnMTbMy2wlNsPPQA21DAP"
}
