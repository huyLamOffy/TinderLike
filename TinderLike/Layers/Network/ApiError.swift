//
//  ApiError.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Alamofire

public enum APIError: Error {
    
    case noInternet
    case requestFailed
    case invalidData
    case unauthorized
    case notfound
    case generic
    case internalServerError
    case userInputError
    case custom(message: String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request failed"
        case .invalidData: return "Invaid data"
        case .unauthorized: return "Unauthorized"
        case .notfound: return "Not found"
        case .generic: return "Failed"
        case .internalServerError: return "Failed"
        case .userInputError: return "Input error"
        case .noInternet : return "No internet"
        case .custom(let message): return message
        }
    }
}

