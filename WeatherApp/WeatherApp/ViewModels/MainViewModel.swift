import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var searchResults = [WeatherModel]()
    @Published var searchText = ""
    @Published var locationSuggestions = [LocationModel]()
    private var network: Networkable
    private var dataHandler: DataHandler
    private var cancellables = Set<AnyCancellable>()
    
    init(network: Networkable = WeatherNetworking.shared, dataHandler: DataHandler = DataController.shared) {
        self.network = network
        self.dataHandler = dataHandler
        dataHandler.weatherModelsPublisher.receive(on: RunLoop.main).sink {[weak self] models in
            guard let self else { return }
            self.searchResults = models
        }.store(in: &cancellables)
        
        $searchText.debounce(for: 0.3, scheduler: DispatchQueue.main).sink { [weak self] text in
            Task { [weak self] in
                await self?.searchAutocompleteText()
            }
        }.store(in: &cancellables)
    }
    
    @MainActor
    func searchAutocompleteText() {
        Task {
            locationSuggestions = try await network.retriveAutocompleteText(text: searchText)
        }
    }
    
    func userSelectedLocation(location: LocationModel) {
        searchText = ""
        locationSuggestions = []
        dataHandler.userSelectedLocation(location: location)
    }
}
