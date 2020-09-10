//
//  Info.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/10/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}
