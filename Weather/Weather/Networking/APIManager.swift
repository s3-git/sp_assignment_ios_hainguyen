//
//  WeatherAPI.swift
//  Weather
//
//  Created by hai.nguyenv on 5/13/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let apiKey = "9c960465626046059ef64401251205"

    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //-------- API to search a city by keywork------------------------------
    func searchCity(query: String, completion: @escaping ([String]) -> Void) {
        
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.worldweatheronline.com/premium/v1/search.ashx?key=\(apiKey)&query=\(encoded)&format=json"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        session.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion([])
                return
            }

            do {
                let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                let cities = result.search_api?.result.map { $0.areaName.first?.value ?? "" } ?? []
                completion(cities)
            } catch {
                completion([])
            }
        }.resume()
    }
    
    //-------- API to fetch weather for a city------------------------------
    func getWeatherByCityName(for city: String, completion: @escaping (CurrentWeather?) -> Void) {
        
        if let cached = CachingManager.shared.getCachedWeather(for: city) {
            completion(cached)
            return
        }
        
        let encoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.worldweatheronline.com/premium/v1/weather.ashx?key=\(apiKey)&q=\(encoded)&format=json&num_of_days=1"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                if let current = response.data.current_condition.first{
                    CachingManager.shared.setCachedWeather(for: city, data: current)
                    completion(current)
                }else{
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}


