//
//  CoreDataTests.swift
//  TinderLikeTests
//
//  Created by HuyLH3 on 9/13/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import XCTest

class CoreDataTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoreData() {
        let person = People.mock
        let id = person.id
        let expectation = self.expectation(description: "Fetching")

        try? LocalDatabaseManager.shared.savePeople(person)
        LocalDatabaseManager.shared.getPeople(withId: id, needDelteRecord: true) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false)
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }

}
