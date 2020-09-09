//
//  Utilites.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation

//MARK: - Gadgets
public func run(after: Double = 1.0, on queue: DispatchQueue = .main, action: @escaping (() -> Void)) {
    queue.asyncAfter(deadline: .now() + after, execute: action)
}
