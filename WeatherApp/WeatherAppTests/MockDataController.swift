import Foundation
@testable import WeatherApp

class MockDataController: DataHandler {
    var weatherModelsPublisher: Published<[WeatherModel]>.Publisher { $weatherModels }
    @Published var weatherModels = [WeatherModel]()
    var userSelectedLocationModelSent: LocationModel?
    
    func userSelectedLocation(location: LocationModel) {
        userSelectedLocationModelSent = location
    }
}
