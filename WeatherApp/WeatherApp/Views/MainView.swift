import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    var isSearching: Bool {
        !viewModel.searchText.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            if isSearching {
                List {
                    ForEach(viewModel.locationSuggestions, id:\.key) { suggestion in
                        Button(action: {
                            viewModel.userSelectedLocation(location: suggestion)
                        }, label: {
                            let description = "\(suggestion.localizedName), \(suggestion.country.localizedName)"
                            Text(description)
                        })
                    }
                }
            } else {
                if viewModel.searchResults.isEmpty {
                    ContentUnavailableView("No current locations", systemImage: "magnifyingglass.circle", description: Text("Use search bar to add locations"))
                }
                List {
                    ForEach(viewModel.searchResults, id: \.key) { model in
                        LocationWeatherView(model: model)
                    }
                }
                
            }
        }.navigationTitle("Search Weather")
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    MainView()
}
