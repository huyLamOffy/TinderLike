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
    var error: APIError? {
        didSet {
            if error != nil { state = .error }
        }
    }
    
    func getPeople() {
        if state == .loading { return}
        state = .loading
        error = nil
        service.getPeople(with: .getPeople(numberOfResults: 50)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseObject):
                strongSelf.updateWithPeopleList(responseObject.results)
            case .failure(let error):
                switch error {
                case .noInternet:
                    strongSelf.loadLocal()
                default:
                    strongSelf.error = error
                }
            }
        }
    }
    
    func localDatabaseStore(people: People) {
        var storedPeople = people
        storedPeople.isFav = true
        try? LocalDatabaseManager.shared.savePeople(storedPeople)
    }
    
    private func loadLocal() {
        LocalDatabaseManager.shared.getFavPeople { [weak self] (result) in
            switch result {
            case .success(let people):
                self?.updateWithPeopleList(people)
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    func updateWithPeopleList(_ people: [People]) {
        if people.isEmpty {
            error = .emptyData
        } else {
            self.people.append(contentsOf: people)
            error = nil
            state = .ordinary
        }
    }
}
