//
//  Extension+Bundle.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 11/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
extension Bundle {
    private static var bundle: Bundle!

    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            // by default english
            Bundle.setLanguage(lang: "en")
            let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? "en"
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            bundle = Bundle(path: path!)
        }
        return bundle
    }

    public static func setLanguage(lang: String) {
        UserDefaults.standard.set(lang, forKey: "app_lang")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
    }
}
