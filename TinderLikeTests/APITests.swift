//
//  APITests.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/10/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import XCTest
@testable import TinderLike

class APITests: XCTestCase {
    var service: PeopleNetworkingServices!
    override func setUp() {
        service = PeopleNetworkingServices()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPI() {
        let timeout: TimeInterval = 5
        let expectation = self.expectation(description: "Fetching")
        service.getPeople(with: .getPeople(numberOfResults: Constant.numberOfResults)) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(let responseObject):
                XCTAssertEqual(responseObject.results.count, Constant.numberOfResults)
            case .failure:
                XCTAssert(false)
            }
        }
        waitForExpectations(timeout: timeout, handler: nil)        
    }
}
