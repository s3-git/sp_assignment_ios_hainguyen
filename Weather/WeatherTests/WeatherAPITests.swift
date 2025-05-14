//
//  WeatherAPITests.swift
//  WeatherTests
//
//  Created by hai.nguyenv on 5/14/25.
//

import Foundation
import XCTest

@testable import Weather

final class WeatherAPITests: XCTestCase {

    func makeMockSession(with json: String) -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockProtocol.self]
        MockProtocol.mockData = json.data(using: .utf8)
        return URLSession(configuration: config)
    }

    func testSearchCityReturnsCityList() {
        let json = """
        {
            "search_api": {
                "result": [
                    { "areaName": [{ "value": "Hanoi" }] },
                    { "areaName": [{ "value": "Hanover" }] }
                ]
            }
        }
        """

        let session = makeMockSession(with: json)
        let api = APIManager(session: session)

        let exp = expectation(description: "searchCity")

        api.searchCity(query: "Ha") { cities in
            XCTAssertEqual(cities.count, 2)
            XCTAssertEqual(cities.first, "Hanoi")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testFetchCurrentWeatherReturnsCorrectData() {
        let json = """
        {
            "data": {
                "current_condition": [{
                    "weatherIconUrl": [{ "value": "https://example.com/icon.png" }],
                    "humidity": "85",
                    "weatherDesc": [{ "value": "Cloudy" }],
                    "temp_C": "25",
                    "temp_F": "80"
                }]
            }
        }
        """

        let session = makeMockSession(with: json)
        let api = APIManager(session: session)

        let exp = expectation(description: "fetchWeather")

        api.getWeatherByCityName(for: "Hanoi"){ weather in
            XCTAssertNotNil(weather)
            XCTAssertEqual(weather?.temp_C, "25")
            XCTAssertEqual(weather?.humidity, "85")
            XCTAssertEqual(weather?.weatherDesc.first?.value, "Cloudy")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}
