//
//  CacheManagerTests.swift
//  WeatherTests
//
//  Created by hai.nguyenv on 5/14/25.
//

import XCTest
@testable import Weather

final class CityHistoryManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        CachingManager.shared.clearSearch()
    }

    func test_AddingCity_SavesToRecentList() {
        CachingManager.shared.addCity("Hanoi")
        let cities = CachingManager.shared.getRecentSearch()
        XCTAssertEqual(cities, ["Hanoi"])
    }

    func test_AddingSameCity_MovesToTop() {
        CachingManager.shared.addCity("Hanoi")
        CachingManager.shared.addCity("HoChiMinh")
        CachingManager.shared.addCity("Hanoi")
        let cities = CachingManager.shared.getRecentSearch()
        XCTAssertEqual(cities, ["Hanoi", "HoChiMinh"])
    }

    func test_RecentList_MaximumIs10() {
        for i in 1...15 {
            CachingManager.shared.addCity("City\(i)")
        }
        let cities = CachingManager.shared.getRecentSearch()
        XCTAssertEqual(cities.count, 10)
        XCTAssertEqual(cities.first, "City15")
        XCTAssertEqual(cities.last, "City6")
    }

    func test_Clear_RemovesAllCities() {
        CachingManager.shared.addCity("Hue")
        CachingManager.shared.clearSearch()
        let cities = CachingManager.shared.getRecentSearch()
        XCTAssertTrue(cities.isEmpty)
    }

    func test_CaseInsensitive_Duplicate() {
        CachingManager.shared.addCity("Hanoi")
        CachingManager.shared.addCity("hAnOi")
        let cities = CachingManager.shared.getRecentSearch()
        XCTAssertEqual(cities.count, 1)
        XCTAssertEqual(cities.first, "hAnOi")
    }
}
