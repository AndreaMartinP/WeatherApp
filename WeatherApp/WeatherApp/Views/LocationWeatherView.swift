//
//  LocationWeatherView.swift
//  WeatherApp
//
//  Created by Andrea Martin on 17/12/23.
//

import SwiftUI

struct LocationWeatherView: View {
    let model: WeatherModel
    
    var body: some View {
        HStack() {
            Text(model.cityName)
                .font(.title)
            Text(model.isDayTime ? "☀️" : "🌙")
            Spacer()
            Text("\(Int(model.temperature))°C")
                .font(.largeTitle)
        }
        .padding()
    }
}

#Preview {
    LocationWeatherView(model: WeatherModel(administrativeArea: "Tamaulipas", cityName: "Tampico", country: "Mexico", key: "2345", temperature: 20, weatherText: "clear", isDayTime: false))
}
