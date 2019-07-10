//
//  DeliveryDetailViewModalTests.swift
//  DeliveryAppTests
//
//  Created by Bhavuk Chawla on 09/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import XCTest
@testable import DeliveryApp

class DeliveryDetailViewModelTests: XCTestCase {
    var viewModel: DeliveryDetailViewModel!
    override func setUp() {
        viewModel = DeliveryDetailViewModel(deliveryData: DeliveryItem())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testAddress() {
        viewModel.dataForDeliveryItem { (address, _) in
            XCTAssertNotNil(address)
        }
    }

    func testLocation() {
        viewModel.dataForMapView { (address, latitude, longitude) in
            XCTAssertNotNil(address)
            XCTAssertNotNil(latitude)
            XCTAssertNotNil(longitude)
        }
    }
    override func tearDown() {
        viewModel = nil
    }

}
