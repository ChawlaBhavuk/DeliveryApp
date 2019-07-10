//
//  DeliveryDetailViewControllerTests.swift
//  DeliveryAppTests
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import XCTest
import MapKit
@testable import DeliveryApp

class DeliveryDetailViewControllerTests: XCTestCase {

    var deliveryDetailVC: DeliveryDetailViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        deliveryDetailVC = DeliveryDetailViewController(viewModel: MockDeleveryDetailViewModal())
        deliveryDetailVC.viewDidLoad()
    }

    func testMapViewDelegateConformance() {
        XCTAssertTrue(deliveryDetailVC.conforms(to: MKMapViewDelegate.self))
    }

    func testNotNilElements() {
        XCTAssertNotNil(deliveryDetailVC.navigationItem.title)
        XCTAssertNotNil(deliveryDetailVC.viewModel)
        XCTAssertNotNil(deliveryDetailVC.mapView)
        XCTAssertNotNil(deliveryDetailVC.deliveryDetailView)
    }

    func testEvents() {
        deliveryDetailVC.viewModel.dataForDeliveryItem { (address, url) in
            XCTAssertEqual(address, "test")
            XCTAssertNil(url)
        }
        deliveryDetailVC.viewModel.dataForMapView { (address, latitude, longitude) in
            XCTAssertEqual(address, "test")
            XCTAssertEqual(latitude, 5.0)
            XCTAssertEqual(longitude, 5.0)
        }
    }

    override func tearDown() {
        deliveryDetailVC = nil
    }
}

class MockDeleveryDetailViewModal: DetailViewEventHandler {
    func dataForMapView(completion: (String, Double, Double) -> Void) {
        completion("test", 5.0, 5.0)
    }

    func dataForDeliveryItem(completion: (String, URL?) -> Void) {
        completion("test", nil)
    }
}
