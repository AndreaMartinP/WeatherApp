import CoreData
import Foundation

protocol DataHandler {
    var weatherModelsPublisher: Published<[WeatherModel]>.Publisher { get }
    func userSelectedLocation(location: LocationModel)
}

class DataController: ObservableObject, DataHandler {
    
    @Published private var weatherModels = [WeatherModel]()
    var weatherModelsPublisher: Published<[WeatherModel]>.Publisher { $weatherModels }
    
    static let shared = DataController()
    
    private let container = NSPersistentContainer(name: "WeatherData")
    private var network: Networkable
    
    init(network: Networkable = WeatherNetworking.shared) {
        self.network = network
        container.loadPersistentStores{ description, error in
            if let error {
                // This error should be handled in the future
                print("Core data failed to load \(error.localizedDescription)")
            }
        }
        fetchSavedLocations()
    }
    
    private func fetchSavedLocations() {
        let request = NSFetchRequest<LocationWeather>(entityName: "LocationWeather")
        //request with order from date added
        do {
            weatherModels = try container.viewContext.fetch(request).map {
                WeatherModel(administrativeArea: $0.administrativeArea ?? "",
                             cityName: $0.cityName ?? "",
                             country: $0.country ?? "",
                             key: $0.key ?? "",
                             temperature: $0.temperature,
                             weatherText: $0.weatherText ?? "",
                             isDayTime: $0.isDayTime)
            }
        }
        catch let error {
            print("Error fetching saved data: \(error)")
        }
    }
    
    func userSelectedLocation(location: LocationModel) {
        Task {
            let response = try await network.retrieveLocationWeather(key: location.key)
            guard let conditions = response.first else { return }
            let model = WeatherModel(administrativeArea: location.administrativeArea.localizedName,
                                     cityName: location.localizedName,
                                     country: location.country.localizedName,
                                     key: location.key,
                                     temperature: conditions.temperature.metric.value,
                                     weatherText: conditions.weatherText,
                                     isDayTime: conditions.isDayTime)
            //needs to handle this error in the future
            try? addLocation(model: model)
        }
    }
    
    private func addLocation(model: WeatherModel) throws {
        let entity: LocationWeather!
        
        let request = NSFetchRequest<LocationWeather>(entityName: "LocationWeather")
        request.predicate = NSPredicate(
            format: "key = %@", "\(model.key)"
        )
        let response = try container.viewContext.fetch(request)
        if let first = response.first {
            entity = first
        } else {
            entity = LocationWeather(context: container.viewContext)
            
        }
        entity.administrativeArea = model.administrativeArea
        entity.cityName = model.cityName
        entity.country = model.country
        entity.key = model.key
        entity.temperature = model.temperature
        entity.weatherText = model.weatherText
        entity.dateCreated = Date()
        saveData()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchSavedLocations()
        }
        catch let error {
            print("Error saving data: \(error)")
        }
    }
}
