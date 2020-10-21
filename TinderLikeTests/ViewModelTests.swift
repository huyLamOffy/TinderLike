//
//  ViewModelTests.swift
//  TinderLikeTests
//
//  Created by HuyLH3 on 9/13/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import XCTest
import Mockingjay

class ViewModelTests: XCTestCase {

    let numberOfResult = Constant.numberOfResults
    var getPeoplePath: String {
        try! PeopleURLRequests.getPeople(numberOfResults: numberOfResult).asURLRequest().url?.absoluteString ?? ""
    }
    
    func testGetPeopleSuccessfully() {
        let expect = expectation(description: "fetching time")
        stub(uri(getPeoplePath), json(String.loadJsonResponse(withFileName: "random_user").json!))
        let viewModel = ViewModel()
        viewModel.getPeople()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            XCTAssert(viewModel.people.count == self.numberOfResult)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetPeopleFailed() {
        let expect = expectation(description: "fetching time")
        stub(uri(getPeoplePath), failure(APIError.internalServerError as NSError))
        let viewModel = ViewModel()
        viewModel.getPeople()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssert(viewModel.error != nil)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}
