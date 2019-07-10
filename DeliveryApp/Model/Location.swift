//
//  Location.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

public class Location: Object {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let lat = "lat"
        static let lng = "lng"
        static let address = "address"
    }

    // MARK: Properties
    @objc dynamic var lat: String!
    @objc dynamic var lng: String!
    @objc dynamic var address: String!

    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    convenience init(json: JSON) {
        self.init()
        lat = json[SerializationKeys.lat].stringValue
        lng = json[SerializationKeys.lng].stringValue
        address = json[SerializationKeys.address].stringValue
    }

}
