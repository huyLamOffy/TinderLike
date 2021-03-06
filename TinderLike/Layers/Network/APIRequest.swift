//
//  APIRequest.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Alamofire

class APIRequest {
    private var sessionManager: Alamofire.Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        
        sessionManager = Alamofire.Session(configuration: configuration)
    }
    
    deinit {
        sessionManager.session.invalidateAndCancel()
    }
    
    func requestObject<T: Decodable>(route: URLRequestConvertible, specificKeyPath keyPath: String? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        guard ReachabilityManager.shared.isNetworkAvailable else {
            completion(.failure(.noInternet))
            return
        }
        sessionManager
            .request(route)
            .validate()
            .responseDecodableObject(keyPath: keyPath, decoder: decoder) { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let object):
                    completion(.success(object))
                case .failure(let error):
                    switch error {
                    case .sessionTaskFailed(let sessionTaskFailedError):
                        if let err = sessionTaskFailedError as? URLError,
                            err.code  == URLError.Code.notConnectedToInternet {
                            completion(.failure(.noInternet))
                            return
                        }
                    default: break
                    }
                    completion(.failure(.custom(message: error.localizedDescription)))
                }
                
        }
    }
    
}

fileprivate var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}

