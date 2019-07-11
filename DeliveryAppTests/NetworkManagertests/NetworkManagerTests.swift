//
//  NetworkRequest.swift
//  DeliveryAppTests
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import XCTest
import Alamofire
@testable import DeliveryApp

class ServiceManagerTests: XCTestCase {

    let host = "mock-api-mobile.dev.lalamove.com"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testValidDeliveryResponse() {
        testDeliveryListWithValidResponseForURL(host: host, fileName: "SuccessResponse.json")
    }

    func testInValidDeliveryResponse() {
        testDeliveryListWithInValidResponseForURL(host: host, fileName: "FailureResponse.json")
    }

    func testEndPoint() {
        let networkManager = NetworkManager()
        let endPoint = networkManager.creatingEndPoint(offset: 0, limit: 20)
        XCTAssertNotNil(endPoint?.baseURL)
        XCTAssertNotNil(endPoint?.httpMethod)
        XCTAssertNotNil(endPoint?.path)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

extension ServiceManagerTests {

    func testDeliveryListWithValidResponseForURL(host: String, fileName: String) {

        XCHttpStub.request(path: host, responseFile: fileName)
        let resultExpectation = expectation(description: "Invalid Json")

        let networkManager: NetworkRouter = NetworkManager()
        networkManager.getDataFromApi(offset: 0, limit: 10) { jsonData, _  in
            XCTAssertEqual(10, jsonData.count)
            resultExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTAssertNotNil(error, "Request timed out")
            }
        }
    }

    func testDeliveryListWithInValidResponseForURL(host: String, fileName: String) {

        XCHttpStub.request(path: host, responseFile: fileName)
        let resultExpectation = expectation(description: "Expected delivery Items")

        let networkManager: NetworkRouter = NetworkManager()
        networkManager.getDataFromApi(offset: 0, limit: 10) { _, error  in
            XCTAssertNotNil(error, "Expectation fulfilled with error")
            resultExpectation.fulfill()
        }

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTAssertNotNil(error, "Request timed out")
            }
        }
    }
}
