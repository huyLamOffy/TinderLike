//
//  URLRequestConvertable.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Alamofire

/// Router request convertible
protocol RouterURLRequestConvertible: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

extension RouterURLRequestConvertible {

    func asURLRequest() throws -> URLRequest {
        let url = try Constant.baseURL.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)

        return urlRequest
    }
}

