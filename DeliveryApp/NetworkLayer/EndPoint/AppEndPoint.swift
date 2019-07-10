//
//  AppEndPoint.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import Alamofire

struct EndPointType {
    var baseURL: URL
    var path: [String: Any]
    var httpMethod: HTTPMethod

    init(baseURL: URL, path: [String: Any], httpMethod: HTTPMethod = .get) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
    }
}

struct APIEndPoint {
    static let baseUrl = "https://mock-api-mobile.dev.lalamove.com/"
    static let deliveryService = "deliveries"
}
