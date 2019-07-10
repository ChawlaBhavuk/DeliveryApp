//
//  DeliveryItem.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

public class DeliveryItem: Object {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let descriptionValue = "description"
        static let location = "location"
        static let imageUrl = "imageUrl"
        static let idValue = "id"
    }

    // MARK: Properties
    @objc dynamic var descriptionValue: String!
    @objc dynamic var location: Location?
    @objc dynamic var imageUrl: String!
    @objc dynamic var idValue: String!

    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    convenience init(json: JSON) {
        self.init()
        descriptionValue = json[SerializationKeys.descriptionValue].stringValue
        location = Location(json: json[SerializationKeys.location])
        imageUrl = json[SerializationKeys.imageUrl].stringValue
        idValue = json[SerializationKeys.idValue].stringValue
    }

    override public static func primaryKey() -> String? {
        return "idValue"
    }
}
