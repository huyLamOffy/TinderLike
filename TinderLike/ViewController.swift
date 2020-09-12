//
//  ViewController.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var peopleCard: PeopleCard!
    
    let service = PeopleNetworkingServices()
    
    //MARK: - View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleCard.people = People.mock
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Navigation
    
    //MARK: - Actions
    
    //MARK: - Private Methods
    
}

