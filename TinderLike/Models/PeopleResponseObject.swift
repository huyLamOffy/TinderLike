//
//  PeopleResponseObject.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/10/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation

// MARK: - PeopleResponseObject
struct PeopleResponseObject: Codable {
    let results: [People]
    let info: Info
}
