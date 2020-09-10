//
//  PeopleNetworkingServices.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/10/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Alamofire

struct PeopleNetworkingServices {
    var clientRequest = APIRequest()

    func getPeople(with route: PeopleURLRequests, completion: @escaping (Result<PeopleResponseObject, APIError>) -> Void) {
        clientRequest.requestObject(route: route, completion: completion)
    }
}
