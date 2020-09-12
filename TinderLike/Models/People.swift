//
//  People.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/10/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation

// MARK: - People
struct People: Codable {
    var name: Name
    var location: Location
    var dob: Dob
    var phone: String
    var picture: Picture
    
    var displayName: String {
        let arr = [name.title.rawValue, name.first, name.last]
        return arr.joined(separator: " ")
    }
    
    var displayDob: String? {
        guard let dob = Date.convert(isoDate: dob.date, toDateFormat: "dd/MM/yyyy") else { return nil }
        return dob + " (\(self.dob.age))"
    }
    
    var displayLocation: String {
        let arr = ["\(location.street.number) " + location.street.name, location.city, location.state, location.country]
        
        return arr.filter({ !$0.isEmpty }).joined(separator: ", ")
    }
    
    var pictureUrl: String {
        get {
            return picture.medium
        } set {
            picture.medium = newValue
        }
    }
}

extension People {
    static var mock: Self {
        let name = Name(title: .mr, first: "Huy", last: "Lam")
        let location = Location.mock
        let dob = Dob(date: "1961-03-03T05:23:57.629Z", age: 59)
        let phone = "+84939393939"
        let pic = "https://www.shareicon.net/data/512x512/2016/08/18/814068_face_512x512.png"
        return Self(name: name, location: location, dob: dob, phone: phone, picture: Picture(medium: pic))
    }
}

// MARK: - Dob
struct Dob: Codable {
    var date: String
    var age: Int
}

// MARK: - Location
struct Location: Codable {
    var street: Street
    var city, state, country: String
    var coordinates: Coordinates
    
    static var mock: Self {
        return Self(street: Street(number: 223, name: "BVD"), city: "HCM", state: "", country: "Viet Name", coordinates: Coordinates(latitude: "10.7575994", longitude: "106.6866392"))
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Street
struct Street: Codable {
    var number: Int
    var name: String
}

// MARK: - Name
struct Name: Codable {
    var title: Title
    var first, last: String
}

enum Title: String, Codable {
    case madame = "Madame"
    case miss = "Miss"
    case monsieur = "Monsieur"
    case mr = "Mr"
    case mrs = "Mrs"
    case ms = "Ms"
}

// MARK: - Picture
struct Picture: Codable {
    var medium: String
}

