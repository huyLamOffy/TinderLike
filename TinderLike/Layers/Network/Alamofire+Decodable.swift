//
//  Alamofire+Decodable.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {

    /// Adds a handler to be called once the request has finished.
     
    /// - parameter queue:             The queue on which the completion handler is dispatched. Default: `.main`.
    /// - parameter keyPath:           The keyPath where object decoding should be performed. Default: `nil`.
    /// - parameter decoder:           The decoder that performs the decoding of JSON into semantic `Decodable` type. Default: `JSONDecoder()`.
    /// - parameter completionHandler: The code to be executed once the request has finished and the data has been mapped by `JSONDecoder`.
     
    /// - returns: The request.
    
    @discardableResult
    public func responseDecodableObject<T: Decodable>(queue: DispatchQueue = .main,
                                                      keyPath: String? = nil,
                                                      decoder: JSONDecoder = JSONDecoder(),
                                                      completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataKeyPathSerializer<T>(keyPath: keyPath, decoder: decoder),
                        completionHandler: completionHandler)
    }
}

/// `AlamofireDecodableError` is the error type returned by CodableAlamofire.
///
/// - invalidKeyPath:   Returned when a nested dictionary object doesn't exist by special keyPath.
/// - emptyKeyPath:     Returned when a keyPath is empty.
/// - invalidJSON:      Returned when a nested json is invalid.

public enum AlamofireDecodableError: Error {
    case invalidKeyPath
    case emptyKeyPath
    case invalidJSON
}

extension AlamofireDecodableError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidKeyPath:   return "Nested object doesn't exist by this keyPath."
        case .emptyKeyPath:     return "KeyPath can not be empty."
        case .invalidJSON:      return "Invalid nested json."
        }
    }
}

internal final class DataKeyPathSerializer<SerializedObject: Decodable>: DataResponseSerializerProtocol {

    private let keyPath: String?
    private let decoder: JSONDecoder

    init(keyPath: String?, decoder: JSONDecoder = JSONDecoder()) {
        self.keyPath = keyPath
        self.decoder = decoder
    }

    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> SerializedObject {
        if let error = error {
            throw error
        }

        if let keyPath = self.keyPath {
            if keyPath.isEmpty {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.emptyKeyPath))
            }

            let json = try JSONResponseSerializer().serialize(request: nil, response: response, data: data, error: nil)
            if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                guard JSONSerialization.isValidJSONObject(nestedJson) else {
                    throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.invalidJSON))
                }
                let data = try JSONSerialization.data(withJSONObject: nestedJson)
                let object = try decoder.decode(SerializedObject.self, from: data)
                return object
            }
            else {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: AlamofireDecodableError.invalidKeyPath))
            }
        } else {
            let data = try DataResponseSerializer().serialize(request: nil, response: response, data: data, error: nil)
            let object = try self.decoder.decode(SerializedObject.self, from: data)
            return object
        }
    }
}
