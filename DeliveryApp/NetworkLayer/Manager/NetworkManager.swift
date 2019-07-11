//
//  NetworkManager.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Crashlytics

typealias ServiceResponse = (JSON, String?) -> Void

enum NetworkResponse: String {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

protocol NetworkRouter: class {
    func getDataFromApi(offset: Int, limit: Int, completion: @escaping ServiceResponse)
}

class  NetworkManager: NetworkRouter {

    private let offsetString = "offset"
    private let limitString = "limit"

    /// for getting data from api
    ///
    /// - Parameters:
    ///   - page: page number
    ///   - completion: callback sending data to origin place
    func getDataFromApi(offset: Int, limit: Int, completion: @escaping ServiceResponse) {
        guard let endpoint = createDeliveryEndPoint(offset: offset, limit: limit)else {
            completion(JSON.null, AppLocalization.errorMessage)
            return
        }
        let url = endpoint.baseURL
        let method = endpoint.httpMethod
        let path = endpoint.path
        Alamofire.request(url, method: method, parameters: path).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data,
                    let jsonData  = try? JSON.init(data: data) {
                    completion(jsonData, nil)
                } else {
                    completion(JSON.null, AppLocalization.errorMessage)
                }
            case .failure(let error):
                Crashlytics.sharedInstance().recordError(error)
                completion(JSON.null, AppLocalization.errorMessage)
                // For developers
                #if DEBUG
                if let statusCode = response.response?.statusCode {
                    print(self.handleNetworkResponse(statusCode))
                } else {
                    print(error.localizedDescription)
                }
                #endif
            }
        }
    }

    /// error code messages
    ///
    /// - Parameter statusCode: status code value
    /// - Returns: error message
    fileprivate func handleNetworkResponse(_ statusCode: Int) -> String {
        switch statusCode {
        case 401...500: return NetworkResponse.authenticationError.rawValue
        case 501...599: return NetworkResponse.badRequest.rawValue
        case 600: return NetworkResponse.outdated.rawValue
        default: return NetworkResponse.failed.rawValue
        }
    }

    /// creating Delivery Endpoint
    ///
    /// - Parameters:
    ///   - offset: offset of request
    ///   - limit: limit value
    /// - Returns: returning value of end point
    func createDeliveryEndPoint(offset: Int, limit: Int) -> EndPointType? {
        if offset >= 0 && limit > 0 {
            let endpoint = APIEndPoint.baseUrl + APIEndPoint.deliveryService
            let params = [offsetString: offset, limitString: limit]
            guard let url = URL(string: endpoint) else {
                return nil
            }
            let endPoint = EndPointType(baseURL: url, path: params, httpMethod: .get)
            return endPoint
        }
        return nil
    }
}
