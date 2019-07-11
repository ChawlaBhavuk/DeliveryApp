//
//  DeliveryListViewModel.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import UIKit
import SwiftyJSON
import Crashlytics

class DeliveryListViewModel: NSObject {

    // MARK: Callbacks
    var reloadData:(() -> Void)?
    var reloadDataWithEmptyMessage:(() -> Void)?
    var showLoader:(() -> Void)?
    var removeLoader:(() -> Void)?
    var endRefreshing:(() -> Void)?
    var beginRefreshing:(() -> Void)?
    var removeAndStopFooter:(() -> Void)?
    var showAndStartFooter:(() -> Void)?
    var showErrorAlert: ((String) -> Void)?
    var emptyAlert: (() -> Void)?

    // MARK: Private members
    private var isPageLoading: Bool = false
    private var offset = 0
    private let limit = 20

    // MARK: Other members
    var deliveryList = [DeliveryItem]()
    var isRefreshing = false
    var networkManager: NetworkRouter = NetworkManager()

    /// for calling first time check data exist in DB or not
    func fetchDeliveries() {
        let deliveries = Array(DBManager.sharedInstance.getDataFromDB())
        if !deliveries.isEmpty {
            self.deliveryList = deliveries
            self.removeLoader?()
            self.reloadData?()
        } else {
            self.requestToServer()
        }
    }

    // MARK: Interaction with model

    /// getting data from request and sending to model
    ///
    /// - Parameter json: data in form of json
    private func updateDataToView(json: JSON) {
        guard let data = DeliveryModel(json: json) else {
            return
        }
        if !data.list.isEmpty {
            self.deliveryList.append(contentsOf: data.list)
            self.reloadData?()
        } else {
            self.emptyAlert?()
            self.isPageLoading = false
            self.forEmptyMessage()
        }
    }

    /// database handling
    private func updateDataToDB() {
        if self.isRefreshing {
            DBManager.sharedInstance.deleteAllFromDatabase()
        }
        if !deliveryList.isEmpty {
            DBManager.sharedInstance.addData(object: deliveryList)
        }
    }

    /// when pull to refresh class
    func pullToRefresh() {
        self.beginRefreshing?()
        self.isRefreshing = true
        self.offset = 0
        self.requestToServer()
    }

    /// For showing empty message
    func forEmptyMessage() {
        if deliveryList.isEmpty {
            self.reloadDataWithEmptyMessage?()
        }
    }

    /// For pagination
    ///
    /// - Parameter indexPaths: visible's indexpaths
    func pagination(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == deliveryList.count - 1 && !isPageLoading {
                self.showAndStartFooter?()
                isPageLoading = true
                offset = deliveryList.count
                self.requestToServer()
            }
        }
    }

    /// managing loading and pagination
    private func updateLoadingState() {
        self.isPageLoading = false
        self.removeLoader?()
        self.removeAndStopFooter?()
    }

}

extension DeliveryListViewModel {

    // MARK: Network call Handling

    /// network call data getting from server
    func requestToServer() {
        guard Connectivity.isConnectedToInternet else {
            self.updateLoadingState()
            self.showErrorAlert?(AppLocalization.noInternetConnection)
            return
        }

        if deliveryList.isEmpty && !isRefreshing {
            // for first showing loader in center of screen
            self.showLoader?()
        }
        if deliveryList.count >= limit {
            // for retry case
            self.showAndStartFooter?()
        }
        networkManager.getDataFromApi(offset: self.offset, limit: self.limit) { [weak self] jsonData, errorMessage  in
            guard let self = self else {
                return
            }
            self.updateLoadingState()
            if let message = errorMessage {
                print("error", message)
                self.showErrorAlert?(message)
            } else {
                if self.isRefreshing {
                    self.deliveryList.removeAll()
                    self.reloadData?()
                    self.endRefreshing?()
                }
                self.updateDataToView(json: jsonData)
                self.updateDataToDB()
                self.isRefreshing = false
            }
        }
    }

}
