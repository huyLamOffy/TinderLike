//
//  ViewModel.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/12/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation

class ViewModel: NSObject {
    let service = PeopleNetworkingServices()
    var people: [People] = []
    var state: ViewController.State = .ordinary {
        didSet {
            stateDidChangedHandler?(state)
        }
    }
    var stateDidChangedHandler: ((ViewController.State) -> Void)?
    private(set) var error: APIError?
    
    func getPeople() {
        if state == .loading { return}
        state = .loading
        error = nil
        service.getPeople(with: .getPeople(numberOfResults: 50)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseObject):
                if responseObject.results.isEmpty {
                    strongSelf.state = .error
                    strongSelf.error = .invalidData
                } else {
                    strongSelf.updateWithPeopleList(responseObject.results)
                }
            case .failure(let error):
                strongSelf.error = error
                strongSelf.state = .error
            }
        }
    }
    
    private func updateWithPeopleList(_ peopleList: [People]) {
        people.append(contentsOf: peopleList)
        error = nil
        state = .ordinary
    }
}
