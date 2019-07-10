//
//  DeliveryModel.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import UIKit
import SwiftyJSON
import Realm
import RealmSwift

class DeliveryModel {

    var list = [DeliveryItem]()

    init?(json: JSON) {
        guard let arr = json.array,
            arr.count > 0 else {
                return
        }
        list = arr.map { DeliveryItem(json: $0) }
    }
}
