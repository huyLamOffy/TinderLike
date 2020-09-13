//
//  PeopleCard.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/12/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import UIKit
import MapKit

class PeopleCard: UIView, NibLoadable {
    
    //MARK: - Properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var container: SwipableContainer!
    @IBOutlet weak var peopleNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var userButton: SelectingButton!
    @IBOutlet weak var calendarButton: SelectingButton!
    @IBOutlet weak var mapButton: SelectingButton!
    @IBOutlet weak var phoneButton: SelectingButton!
    @IBOutlet weak var lockButton: SelectingButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var didRemovedCardHandler: (() -> Void)?
    var isFavCardHandler: (() -> Void)?
    static let height: CGFloat = 400
    var people: People? {
        didSet {
            updateUI()
        }
    }
    private var buttons: [SelectingButton] {
        [
            userButton,
            calendarButton,
            mapButton,
            phoneButton,
            lockButton
        ]
    }
    
    //MARK: - View Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        commonInit()
    }
    
    private func commonInit() {
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        avatarImageView.layer.borderWidth = 1
        
        userButton.iconPath = "icon_user"
        calendarButton.iconPath = "icon_calendar"
        mapButton.iconPath = "icon_map"
        phoneButton.iconPath = "icon_phone"
        lockButton.iconPath = "icon_lock"
        
        userButton.isSelecting = true
        
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        
        container.applyCard(cornerRadius: 12, shadowColor: .black, offset: CGSize(width: 0, height: 2), blur: 6)
        
        container.didRemovedCardHandler = { [weak self] in
            self?.didRemovedCardHandler?()
        }
        
        container.didGoRightHandler = { [weak self] in
            self?.isFavCardHandler?()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.layer.masksToBounds = true
    }
    
    //MARK: - Actions
    @IBAction func userButtonTapped(_ sender: SelectingButton) {
        select(button: sender)
    }
    
    @IBAction func calendarButtonTapped(_ sender: SelectingButton) {
        select(button: sender)
    }
    
    @IBAction func mapButtonTapped(_ sender: SelectingButton) {
        select(button: sender)
    }
    
    @IBAction func phoneButtonTapped(_ sender: SelectingButton) {
        select(button: sender)
    }
    
    @IBAction func lockButtonTapped(_ sender: SelectingButton) {
        select(button: sender)
    }
    
    //MARK: - Private Methods
    private func select(button: SelectingButton) {
        if button.isSelecting { return }
        buttons.forEach { $0.isSelecting = false }
        button.isSelecting = true
        scrollToRelevantView()
    }
    
    private func scrollToRelevantView() {
        var selectedIndex = 0
        for (index, button) in buttons.enumerated() {
            if button.isSelecting { selectedIndex = index; break; }
        }
        let xPoint = scrollView.bounds.width * CGFloat(selectedIndex)
        scrollView.setContentOffset(CGPoint(x: xPoint, y: 0), animated: true)
    }
    
    private func updateUI() {
        guard let people = people else { return }
        avatarImageView.loadImage(urlString: people.pictureUrl)
        peopleNameLabel.text = people.displayName
        dobLabel.text = people.displayDob
        phoneNumberLabel.text = people.phone

        let latitude = people.location.coordinates.exactlyLatitude
        let longitude = people.location.coordinates.exactlyLongitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if CLLocationCoordinate2DIsValid(center) {
            locationMapView.setCenter(center, animated: false)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = people.displayLocation
            locationMapView.addAnnotation(annotation)
        }
    }
}

class SelectingButton: UIButton {
    
    //MARK: - Properties
    var isSelecting: Bool = false {
        didSet {
            updatedUI()
        }
    }
    
    var iconPath: String = "" {
        didSet {
            updatedUI()
        }
    }
    
    //MARK: - View Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Private Methods
    private func updatedUI() {
        let iconPath = isSelecting ? self.iconPath + "_selected" : self.iconPath
        setImage(UIImage(named: iconPath), for: .normal)
    }
    
    private func setup() { }
}

