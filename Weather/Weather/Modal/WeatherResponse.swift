//
//  WatherResponse.swift
//  Weather
//
//  Created by hai.nguyenv on 5/13/25.
//

import Foundation

struct WeatherResponse: Codable {
    let data: WeatherData
}

struct WeatherData: Codable {
    let current_condition: [CurrentWeather]
}

struct CurrentWeather: Codable {
    let weatherIconUrl: [WeatherURL]
    let humidity: String
    let weatherDesc: [WeatherDescription]
    let temp_C: String
    let temp_F: String
}

struct WeatherURL: Codable {
    let value: String
}

struct WeatherDescription: Codable {
    let value: String
}
