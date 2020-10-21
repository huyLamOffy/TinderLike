//
//  String+Extensions.swift
//  TinderLike
//
//  Created by HuyLH3 on 10/21/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation

extension String {
    /// Read string from a file at a given path. Return an empty string for any failure processes.
    static func loadJsonResponse(withFileName fileName: String) -> String {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return "" }
        
        do {
            return try String.init(contentsOfFile: path)
        } catch {
            print("Failed to read a Json response, please check the file name!")
            return ""
        }
    }
    
    var json: [String: Any]? {
        guard
            let data = self.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
        return json
    }
}
