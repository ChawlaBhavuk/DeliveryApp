//
//  Extension+UITableView.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 04/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyView(title: String, message: String) {
        if self.backgroundView == nil {
            let emptyView = UIView()
            self.backgroundView = emptyView
            emptyView.anchor(top: self.topAnchor, left: self.leftAnchor,
                             bottom: self.bottomAnchor, right: self.rightAnchor,
                             paddingTop: AppConstant.zero, paddingLeft: AppConstant.zero,
                             paddingBottom: AppConstant.zero, paddingRight: AppConstant.zero,
                             width: self.frame.width, height: self.frame.height,
                             enableInsets: false)

            let titleLabel = UILabel()
            let messageLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.boldSystemFont(ofSize: AppConstant.fontSize)
            messageLabel.textColor = UIColor.lightGray
            messageLabel.font = UIFont.systemFont(ofSize: AppConstant.fontSize)
            emptyView.addSubview(titleLabel)
            emptyView.addSubview(messageLabel)
            titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor,
                                                constant: -AppConstant.extraLargePadding).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

            messageLabel.anchor(top: titleLabel.topAnchor, left: emptyView.leftAnchor,
                                bottom: nil, right: emptyView.rightAnchor,
                                paddingTop: AppConstant.extraLargePadding,
                                paddingLeft: AppConstant.commonPadding,
                                paddingBottom: AppConstant.commonPadding,
                                paddingRight: AppConstant.commonPadding,
                                width: AppConstant.zero, height: AppConstant.zero,
                                enableInsets: false)

            titleLabel.text = title
            messageLabel.text = message
            messageLabel.numberOfLines = AppConstant.numberOfLines
            messageLabel.textAlignment = .center
        }
    }

    func resetBackgroundView() {
        self.backgroundView = nil
    }
}
