//
//  DeliveryListViewTests.swift
//  DeliveryAppTests
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import XCTest
@testable import DeliveryApp

class DeliveryListViewControllerTests: XCTestCase {
    var deliveryListViewController: DeliveryListViewController = (AppDelegate.delegate().window?.rootViewController
        as! UINavigationController).viewControllers.first
        as! DeliveryListViewController

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testTableViewDelegateConformance() {
        XCTAssertTrue(deliveryListViewController.conforms(to: UITableViewDelegate.self))
    }

    func testTableViewDataSourceConformance() {
        XCTAssertTrue(deliveryListViewController.conforms(to: UITableViewDataSource.self))
    }

    func testRequiredElementShouldNotNil() {
        XCTAssertNotNil(deliveryListViewController.navigationItem.title)
        XCTAssertNotNil(deliveryListViewController.tableView)
    }

    func testRefreshController() {
        XCTAssertNotNil(deliveryListViewController.tableView.refreshControl)
    }

    func testErrorDialogue() {
        deliveryListViewController.showErrorAlert(error: AppLocalization.errorMessage)
        let expectation = XCTestExpectation(description: "UIAlertController should present on ViewController")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            if let presentedViewController = self.deliveryListViewController.presentedViewController {
                XCTAssertTrue(presentedViewController is UIAlertController)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 0.5)
    }

    func testEmptyDialogue() {
        deliveryListViewController.showEmptyAlert()
        let expectation = XCTestExpectation(description: "UIAlertController should present on ViewController")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            if let presentedViewController = self.deliveryListViewController.presentedViewController {
                XCTAssertTrue(presentedViewController is UIAlertController)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 0.5)
    }

    func testDeliveryDetailViewControllerOntoStack() {
        let navigationController = MockNavigationController(rootViewController: deliveryListViewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        deliveryListViewController.pushToDeliveryDetailController(deliveryData: DeliveryItem())
        XCTAssertTrue(navigationController.pushedViewController is DeliveryDetailViewController)
    }

    func testEmptyView() {
        deliveryListViewController.tableView.setEmptyView(title:
            AppLocalization.noData, message: AppLocalization.pullToRefresh)
         XCTAssertNotNil(self.deliveryListViewController.tableView.backgroundView)
    }

}

class MockNavigationController: UINavigationController {

    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: true)
    }
}
