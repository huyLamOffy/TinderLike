//
//  Date+Extensions.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/12/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation

extension Date {
    static func convert(isoDate date: String, fromFormat from: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toDateFormat to: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        guard let date = dateFormatter.date(from: date) else {
            return nil
        }
        dateFormatter.dateFormat = to
        return dateFormatter.string(from: date)
    }
}
