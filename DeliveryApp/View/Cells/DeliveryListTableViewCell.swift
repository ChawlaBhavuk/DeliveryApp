//
//  DeliveryListTableViewCell.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import UIKit
import Kingfisher

class DeliveryListTableViewCell: UITableViewCell {

    private let imageHeight: CGFloat = 90
    private let imageWidth: CGFloat = 90

    // MARK: Creating view

    private lazy var parentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = AppConstant.borderWidth
        return view
    }()

    private lazy var deliveryLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: AppConstant.fontSize)
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = AppConstant.numberOfLines
        lbl.textAlignment = .left
        return lbl
    }()

    private lazy var deliveryImage: UIImageView = {
        let imgView = UIImageView(image: nil)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    // MARK: Assigning data to view

    /// setting data to view using property observer
    var item: DeliveryItem! {
        didSet {
            self.setDataToView()
        }
    }

    private func setDataToView() {
        let address = " " + AppLocalization.atString + " " + (item.location?.address ?? "" )
        self.deliveryLabel.text = item.descriptionValue + address
        if  let imageUrl = item.imageUrl,
            let url = URL(string: imageUrl) {
            self.deliveryImage.kf.setImage(with: url,
                                           placeholder: UIImage(named: "placeholder"),
                                           options: nil, progressBlock: nil) { _ in
            }
        }
    }
    // MARK: Setting view

    /// adding view and assigning constraints
    ///
    /// - Parameters:
    ///   - style: tableview style
    ///   - reuseIdentifier: identifier string
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(parentView)
        parentView.addSubview(deliveryImage)
        parentView.addSubview(deliveryLabel)

        parentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                          paddingTop: AppConstant.commonPadding, paddingLeft: AppConstant.commonPadding,
                          paddingBottom: AppConstant.commonPadding, paddingRight: AppConstant.commonPadding,
                          width: AppConstant.zero, height: 0, enableInsets: false)

        deliveryImage.anchor(top: parentView.topAnchor, left: parentView.leftAnchor,
                             bottom: nil, right: nil, paddingTop: AppConstant.commonPadding,
                             paddingLeft: AppConstant.commonPadding,
                             paddingBottom: AppConstant.zero,
                             paddingRight: AppConstant.zero, width: imageWidth,
                             height: imageHeight, enableInsets: false)

        deliveryLabel.anchor(top: parentView.topAnchor, left: deliveryImage.rightAnchor,
                             bottom: parentView.bottomAnchor, right: parentView.rightAnchor,
                             paddingTop: AppConstant.commonPadding,
                             paddingLeft: AppConstant.commonPadding,
                             paddingBottom: AppConstant.commonPadding,
                             paddingRight: AppConstant.largePadding,
                             width: AppConstant.zero, height: AppConstant.zero,
                             enableInsets: false)

        deliveryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(imageHeight)).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
