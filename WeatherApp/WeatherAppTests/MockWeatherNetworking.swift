import Foundation
@testable import WeatherApp

class MockWeatherNetworking: Networkable {
    
    var retrieveLocationWeatherKey: String?
    var retrieveLocationWeatherKeyReturn = [CurrentCondition]()
    func retrieveLocationWeather(key: String) async throws -> [CurrentCondition] {
        retrieveLocationWeatherKey = key
        return retrieveLocationWeatherKeyReturn
    }
    
    var retriveAutocompleteTextText: String?
    var retriveAutocompleteTextreturn = [LocationModel]()
    func retriveAutocompleteText(text: String) async throws -> [LocationModel] {
        retriveAutocompleteTextText = text
        return retriveAutocompleteTextreturn
    }
}
