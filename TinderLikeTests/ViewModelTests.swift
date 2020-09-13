//
//  ViewModelTests.swift
//  TinderLikeTests
//
//  Created by HuyLH3 on 9/13/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import XCTest

class ViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testErrorState() {
        let viewModel = ViewModel()
        viewModel.stateDidChangedHandler = { newState in
            XCTAssertTrue(newState == .error)
        }
        
        viewModel.error = APIError.generic
    }

    func testEmptyPeopleData() {
        let viewModel = ViewModel()
        viewModel.stateDidChangedHandler = { newState in
            XCTAssertTrue(newState == .error)
            switch viewModel.error {
            case .emptyData:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
        
        viewModel.updateWithPeopleList([])
    }
    
    func testOrdinaryState() {
        let viewModel = ViewModel()
        viewModel.stateDidChangedHandler = { newState in
            XCTAssertTrue(newState == .ordinary)
            XCTAssertTrue(viewModel.people.count == 1)
        }
        
        viewModel.updateWithPeopleList([People.mock])
    }
}
