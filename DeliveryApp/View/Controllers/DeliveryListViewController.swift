//
//  DeliveryListViewController.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import UIKit
import SVProgressHUD

class DeliveryListViewController: UITableViewController {

    var viewModel = DeliveryListViewModel()
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = AppLocalization.thingsToDeliver
        self.responseHandlerFromViewModal()
        self.setupUI()
        viewModel.fetchDeliveries()
    }

    // MARK: Setting view

    /// assigning values to tableview
    func setupUI() {
        //Registers a class for use in creating new table cells.
        tableView.register(DeliveryListTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.addSpinner()
    }

    /// for bottom spinner
    func addSpinner() {
        let spinner = UIActivityIndicatorView(style: .gray)
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }

    // MARK: Actions handled

    /// refreshing data
    ///
    /// - Parameter sender: object of sender
    @objc func refreshData( _ sender: AnyObject) {
        viewModel.pullToRefresh()
    }

    /// showing alert on error
    ///
    /// - Parameter error: title for error
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: AppLocalization.warning,
                                      message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppLocalization.retry,
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
                                        self.viewModel.requestToServer()
        }))
        alert.addAction(UIAlertAction(title: AppLocalization.cancel,
                                      style: UIAlertAction.Style.cancel,
                                      handler: { _ in
                                        self.viewModel.removeAndStopFooter?()
                                        if self.viewModel.isRefreshing {
                                            self.viewModel.isRefreshing = false
                                            self.viewModel.endRefreshing?()
                                        }
                                        self.viewModel.forEmptyMessage()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    /// For empty data alert
    func showEmptyAlert() {
        let alert = UIAlertController(title: AppLocalization.warning,
                                      message: AppLocalization.noData,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppLocalization.okString,
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
                                        self.viewModel.removeAndStopFooter?()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: Data handler from view model

    /// handling responses from view model
    func responseHandlerFromViewModal() {

        self.viewModel.showLoader = {
            SVProgressHUD.show(withStatus: AppLocalization.loading)
        }

        self.viewModel.removeLoader = {
            SVProgressHUD.dismiss()
        }

        self.viewModel.beginRefreshing = { [weak self] in
            self?.tableView.refreshControl?.beginRefreshing()
        }

        self.viewModel.endRefreshing = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }

        self.viewModel.showAndStartFooter = { [weak self] in
            self?.tableView.tableFooterView?.isHidden = false
            if let spinner = self?.tableView.tableFooterView as? UIActivityIndicatorView {
                spinner.startAnimating()
            }
        }

        self.viewModel.removeAndStopFooter = { [weak self] in
            if let spinner = self?.tableView.tableFooterView as? UIActivityIndicatorView {
                spinner.stopAnimating()
            }
            self?.tableView.tableFooterView?.isHidden = true
        }

        self.viewModel.showErrorAlert = { [weak self] (error) in
            self?.showErrorAlert(error: error)
        }

        self.viewModel.emptyAlert = { [weak self] in
            self?.showEmptyAlert()
        }

        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.resetBackgroundView()
                self?.tableView.reloadData()
            }
        }

        viewModel.reloadDataWithEmptyMessage = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.setEmptyView(title: AppLocalization.noData, message: AppLocalization.pullToRefresh)
                self?.tableView.reloadData()
            }
        }

    }

    // MARK: Move to next controller

    /// moving to next controller
    ///
    /// - Parameter deliveryData: dalivery details object
    func pushToDeliveryDetailController(deliveryData: DeliveryItem) {
        let viewModal: DetailViewEventHandler = DeliveryDetailViewModel(deliveryData: deliveryData)
        let viewController = DeliveryDetailViewController(viewModel: viewModal)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DeliveryListViewController {

    // MARK: Tableview implementation

    /// for displaying number of rows in section
    ///
    /// - Parameters:
    ///   - tableView: object of tableview
    ///   - section: rows for partivular section
    /// - Returns: number of rows exist
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.deliveryList.count
    }

    /// displaying view for particular cell
    ///
    /// - Parameters:
    ///   - tableView: object of tableview
    ///   - indexPath: indexpath for particular section and row
    /// - Returns: view for cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            as? DeliveryListTableViewCell {
            cell.accessoryType = .disclosureIndicator
            cell.item = viewModel.deliveryList[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

    /// while tapping on particular cell
    ///
    /// - Parameters:
    ///   - tableView: object of tableview
    ///   - indexPath: indexpath for particular section and row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToDeliveryDetailController(deliveryData: viewModel.deliveryList[indexPath.row])
    }

    // MARK: Pagination

    /// When scrollview's scrolling ends
    ///
    /// - Parameter scrollView: UIScrollView's object
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView,
            let indexPaths = tableView.indexPathsForVisibleRows {
            viewModel.pagination(indexPaths: indexPaths)
        }
    }

}
