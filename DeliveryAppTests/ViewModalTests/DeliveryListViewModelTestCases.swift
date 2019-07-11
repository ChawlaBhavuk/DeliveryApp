//
//  DeliveryListViewModalTestCases.swift
//  DeliveryAppTests
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON
import OHHTTPStubs
import Alamofire
import Realm
import RealmSwift

@testable import DeliveryApp

class DeliveryListViewModelTestCases: XCTestCase {
    var viewModel: DeliveryListViewModel!
    var mockNetworkManager: MockNetworkManager!
    override func setUp() {
        viewModel = DeliveryListViewModel()
        mockNetworkManager = MockNetworkManager()
        viewModel?.networkManager = mockNetworkManager
        DBManager.sharedInstance.database = try!
            Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TempDatabase"))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testFetchWithSuccessService() {
        self.viewModel.fetchDeliveries()
        XCTAssertTrue(self.viewModel.deliveryList.count == 1)
    }

    func testFetchWithErrorService() {
        self.mockNetworkManager.isError = true
        self.viewModel.fetchDeliveries()
        XCTAssertTrue(self.viewModel.deliveryList.count == 0)
    }

    func testFetchWithLocalStorage() {
        self.viewModel.fetchDeliveries()
        XCTAssertEqual(Array(DBManager.sharedInstance.getDataFromDB()).count, 1)
    }

    func createMockDeliveryData(idValue: Int) -> [String: Any] {
        let deliveryLocation = ["lat": 28.7041, "lng": 77.1025,
                                "address": "Deliver documents to Andrio"] as [String: Any]
        let deliveyData = ["imageUrl": "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-6.jpeg",
                           "description": "Deliver documents to Andrio",
                           "id": idValue,
                           "location": deliveryLocation
            ] as [String: Any]
        return deliveyData
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
    }

}
class MockNetworkManager: NetworkRouter {
    var isError = false
    var noMoreResults = false
    func getDataFromApi(offset: Int, limit: Int, completion: @escaping ServiceResponse) {
        if isError {
            completion(JSON.null, AppLocalization.errorMessage)
        } else {
            let jsonData = JSON([self.createMockDeliveryData(idValue: 2)])
            completion(jsonData, nil)
        }
    }

    func createMockDeliveryData(idValue: Int) -> [String: Any] {
        let deliveryLocation = ["lat": 28.7041, "lng": 77.1025,
                                "address": "Deliver documents to Andrio"] as [String: Any]
        let deliveyData = ["imageUrl": "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-6.jpeg",
                           "description": "Deliver documents to Andrio",
                           "id": idValue,
                           "location": deliveryLocation
            ] as [String: Any]
        return deliveyData
    }
}
