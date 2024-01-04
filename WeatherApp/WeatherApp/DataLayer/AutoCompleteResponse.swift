import Foundation

struct LocationModel: Decodable {
    var key: String
    var localizedName: String
    var country: LocationCountry
    var administrativeArea: LocationAdministrativeArea
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case localizedName = "LocalizedName"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
    }
}

struct LocationCountry: Decodable {
    var id: String
    var localizedName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
    }
}

struct LocationAdministrativeArea: Decodable {
    var id: String
    var localizedName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
    }
}
