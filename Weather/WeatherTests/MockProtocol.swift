//
//  MockProtocol.swift
//  WeatherTests
//
//  Created by hai.nguyenv on 5/14/25.
//

import Foundation

class MockProtocol: URLProtocol {
    static var mockData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let data = MockProtocol.mockData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
