//
//  SearchResponse.swift
//  Weather
//
//  Created by hai.nguyenv on 5/13/25.
//

import Foundation

struct SearchResponse: Codable {
    let search_api: SearchAPIResult?
}

struct SearchAPIResult: Codable {
    let result: [CityResult]
}

struct CityResult: Codable {
    let areaName: [CityName]
}

struct CityName: Codable {
    let value: String
}
