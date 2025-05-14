//
//  CachingManager.swift
//  Weather
//
//  Created by hai.nguyenv on 5/13/25.
//

import Foundation

#if DEBUG

class CachingManager {
    static let shared = CachingManager()
    private let key = "recentSearch"
    
    internal var cache: [String: CachedWeather] = [:]
    

    func addCity(_ city: String) {
        var cities = getRecentSearch()
        cities.removeAll(where: { $0.lowercased() == city.lowercased() })
        cities.insert(city, at: 0)
        if cities.count > 10 {
            cities = Array(cities.prefix(10))
        }
        UserDefaults.standard.set(cities, forKey: key)
    }
    func clearSearch() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    func getRecentSearch() -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    
    func getCachedWeather(for city: String) -> CurrentWeather? {
        let key = city.lowercased()
        guard let entry = cache[key] else { return nil }
        let now = Date()
        if now.timeIntervalSince(entry.timestamp) < 60 {
            return entry.data
        }
        return nil
    }
    
    func setCachedWeather(for city: String, data: CurrentWeather) {
        let key = city.lowercased()
        cache[key] = CachedWeather(data: data, timestamp: Date())
    }
    
}

struct CachedWeather {
    let data: CurrentWeather
    let timestamp: Date
}
#endif
