//
//  ViewController.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum State {
        case loading, ordinary, error
    }
    
    //MARK: - Properties
    @IBOutlet weak var toastLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var peopleCard: PeopleCard?
    private var hideToastWorkItem: DispatchWorkItem?
    private var viewModel = ViewModel()
    private lazy var favListView = CustomView(frame: view.frame)
    
    //MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        toastLabel.layer.cornerRadius = 5
        toastLabel.layer.masksToBounds = true
        viewModel.stateDidChangedHandler = { [weak self] _ in
            self?.updateUI()
        }
        
        viewModel.getPeople()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Navigation
    
    //MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        viewModel.getPeople()
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        peopleCard?.container.cardGoesRight()
    }
    
    //MARK: - Private Methods
    private func updateUI() {
        let kRotationAnimation = "rotation_animation"
        switch viewModel.state {
        case .loading:
            refreshButton.addRotation(withDuration: 1.0, forKey: kRotationAnimation)
        case .ordinary:
            refreshButton.layer.removeAnimation(forKey: kRotationAnimation)
            if peopleCard == nil {
                addNewCardPeople()
            }
        case .error:
            refreshButton.layer.removeAnimation(forKey: kRotationAnimation)
            guard let error = viewModel.error else { return }
            switch error {
            case .noInternet:
                break
            default:
                show(error: error)
            }
        }
    }
    
    private func showToast(_ message: String?) {
        toastLabel.text = message
        toastLabel.alpha = 1.0
        
        hideToastWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.hideToast()
        })
        hideToastWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: requestWorkItem)
    }
    
    private func hideToast() {
        UIView.animate(withDuration: 0.25, animations: {
            self.toastLabel.alpha = 0.0
        }, completion: { _ in
            self.toastLabel.text = nil
        })
    }
    
    private func checkLoadMorePeople() {
        if viewModel.people.count < 10 {
            viewModel.getPeople()
        }
    }
    
    private func addNewCardPeople() {
        guard let people = viewModel.people.first else { return }
        let yPoint = (view.bounds.height - PeopleCard.height) / 2
        peopleCard = PeopleCard(frame: CGRect(x: 20, y: yPoint, width: view.bounds.width - 40, height: PeopleCard.height))
        guard let peopleCard = peopleCard else {
            return
        }
        peopleCard.people = people
        view.addSubview(peopleCard)
        peopleCard.isFavCardHandler = { [weak self] in
            guard
                let people = self?.peopleCard?.people,
                !people.isFav // not save people already in local
                else { return }
            
            self?.viewModel.localDatabaseStore(people: people)
            self?.showToast("Added \(people.name.first) to favorite list.")
        }
        
        peopleCard.didRemovedCardHandler = { [weak self] in
            self?.peopleCard?.removeFromSuperview()
            self?.peopleCard = nil
            self?.checkLoadMorePeople()
            self?.addNewCardPeople()
        }
        
        viewModel.people.removeFirst()
    }
}

class CustomView: UIView {
    
    var tableView: UITableView!
    
    func commonInit() {
        // setup tableview
        // offset table 50
        // add gesture to dismiss view
    }
    
}
