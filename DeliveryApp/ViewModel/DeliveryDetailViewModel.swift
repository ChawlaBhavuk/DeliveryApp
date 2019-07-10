//
//  DeliveryDetailViewModel.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import UIKit

protocol DetailViewEventHandler {
    func dataForMapView(completion: (String, Double, Double) -> Void)
    func dataForDeliveryItem(completion: (String, URL?) -> Void)
}

class DeliveryDetailViewModel: NSObject, DetailViewEventHandler {
    let deliveryData: DeliveryItem

    init(deliveryData: DeliveryItem) {
        self.deliveryData = deliveryData
    }

    /// Get address, latitude and longitude
    ///
    /// - Parameter completion: String: Address, Double: latitude, Double: Longitude
    func dataForMapView(completion: (String, Double, Double) -> Void) {
        if let loc = deliveryData.location,
            let address = loc.address,
            let lati = Double(loc.lat),
            let long = Double(loc.lng) {
            completion(address, lati, long)
        }
    }

    /// Formating data of delivery item
    ///
    /// - Parameter completion: String: address of delivery, Url: Image url
    func dataForDeliveryItem(completion: (String, URL?) -> Void) {
        let address = " " + AppLocalization.atString + " " + (deliveryData.location?.address ?? "" )
        let completeAddress = (deliveryData.descriptionValue ?? "") + address
        completion(completeAddress, URL(string: deliveryData.imageUrl ?? ""))
    }

}
