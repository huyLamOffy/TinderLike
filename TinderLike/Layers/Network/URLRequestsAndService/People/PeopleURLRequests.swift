//
//  PeopleURLRequests.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/10/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Alamofire

enum PeopleURLRequests: RouterURLRequestConvertible {
    case getPeople(numberOfResults: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getPeople:
            return .get
        }
    }
    
    var path: String {
        return ""
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPeople(let numberOfResults):
            return ["results": numberOfResults]
        }
    }
}
