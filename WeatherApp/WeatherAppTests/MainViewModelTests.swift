import XCTest
@testable import WeatherApp
import Combine

final class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    var mockDataController: MockDataController!
    var mockWeatherNetworking: MockWeatherNetworking!
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        mockDataController = MockDataController()
        mockWeatherNetworking = MockWeatherNetworking()
        sut = MainViewModel(network: mockWeatherNetworking, dataHandler: mockDataController)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchAutocompleteText() async throws {
        sut.searchText = "test"
        let suggestionExp = expectation(description: "suggestion")
        
        sut.$locationSuggestions
            .dropFirst()
            .sink { locations in
                if locations.first != nil {
                    suggestionExp.fulfill()
                }
        }.store(in: &cancellables)
        let testLocation = LocationModel(key: "testKey",
                                          localizedName: "testCityName",
                                          country: LocationCountry(id: "testId", localizedName: "testCountryName"),
                                          administrativeArea: LocationAdministrativeArea(id: "testId", localizedName: "testAdministrativeArea"))
        mockWeatherNetworking.retriveAutocompleteTextreturn = [testLocation]
        await sut.searchAutocompleteText()
           
        await fulfillment(of: [suggestionExp])
        XCTAssertNotNil(mockWeatherNetworking.retriveAutocompleteTextText)
        let text = try XCTUnwrap(mockWeatherNetworking.retriveAutocompleteTextText)
        XCTAssertEqual(text, sut.searchText)

    }

    func testUserSelectedLocation() throws {
        let testLocation = LocationModel(key: "testKey",
                                          localizedName: "testCityName",
                                          country: LocationCountry(id: "testId", localizedName: "testCountryName"),
                                          administrativeArea: LocationAdministrativeArea(id: "testId", localizedName: "testAdministrativeArea"))
        sut.searchText = "test search"
        sut.locationSuggestions = [testLocation]
        
        let locationExp = expectation(description: "loc")
        
        sut.$locationSuggestions
            .dropFirst()
            .sink { locations in
            if locations.isEmpty {
                locationExp.fulfill()
            }
        }.store(in: &cancellables)
        
        let searchTextExp = expectation(description: "searchText")
        
        sut.$searchText
            .dropFirst()
            .sink { text in
                if text.isEmpty {
                    searchTextExp.fulfill()
                }
            }.store(in: &cancellables)
        
        
        
        sut.userSelectedLocation(location: testLocation)
        
        XCTAssertNotNil(mockDataController.userSelectedLocationModelSent)
        let location = try XCTUnwrap(mockDataController.userSelectedLocationModelSent)
        XCTAssertEqual(location.key, testLocation.key)
        
        wait(for: [locationExp, searchTextExp], timeout: 1)
    }

}
