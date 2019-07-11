//
//  DBManager.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DBManager {
    var database: Realm
    static let sharedInstance = DBManager()
    private init() {
        database = try! Realm()
    }

    // MARK: Database operations

    /// getting data of list
    ///
    /// - Returns: return DeliveryItem array
    func getDataFromDB() -> Results<DeliveryItem> {
        let results: Results<DeliveryItem> = database.objects(DeliveryItem.self)
        return results
    }

    /// For adding object
    ///
    /// - Parameter object: DeliveryItem's object value
    func addData(object: [DeliveryItem]) {
        do {
            try database.write {
                database.add(object, update: .all)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }

    /// removing all data from database
    func deleteAllFromDatabase() {
        do {
            try database.write {
                database.deleteAll()
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
