//
//  CityDetailView.swift
//  Weather
//
//  Created by hai.nguyenv on 5/13/25.
//

import SwiftUI

struct CityDetailView: View {
    
    var cityName: String

    @State private var weather: CurrentWeather?
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                ProgressView("Loading...")
            } else if let weather = weather {
                AsyncImage(url: URL(string: weather.weatherIconUrl.first?.value ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } else {
                        ProgressView()
                    }
                }

                Text(weather.weatherDesc.first?.value ?? "")
                    .font(.headline)

                Text("Temperature: \(weather.temp_C)°C  or  \(weather.temp_F)°F")
                Text("Humidity: \(weather.humidity)%")
            } else {
                Text("No weather data.")
            }
        }
        .padding()
        .navigationTitle(cityName)
        .onAppear {
            APIManager.shared.getWeatherByCityName(for: cityName) { data in
                DispatchQueue.main.async {
                    self.weather = data
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    CityDetailView(cityName: "Ha noi")
}
