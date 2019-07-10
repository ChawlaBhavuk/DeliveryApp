//
//  RealmOperationTests.swift
//  DeliveryAppTests
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift
import SwiftyJSON
@testable import DeliveryApp

class RealmOperationTests: XCTestCase {

    override func setUp() {
        DBManager.sharedInstance.database = try!
            Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TempDatabase"))
        self.initStubs()
    }

    func testDeliveryListCount() {
        let deliveryList = Array(DBManager.sharedInstance.getDataFromDB())
        XCTAssertEqual(deliveryList.count, 6)
    }

    func testDeliveryDeletionCount() {
        DBManager.sharedInstance.deleteAllFromDatabase()
        let deliveryList = Array(DBManager.sharedInstance.getDataFromDB())
        XCTAssertEqual(deliveryList.count, 0)
    }

    func initStubs() {
        var modelData = [[String: Any]]()
        for index in 0...5 {
            modelData.append(self.createMockDeliveryData(idValue: index))
        }
        let jsonData = JSON(modelData)
        guard let data = DeliveryModel(json: jsonData) else {
            return
        }
        DBManager.sharedInstance.addData(object: data.list)
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
