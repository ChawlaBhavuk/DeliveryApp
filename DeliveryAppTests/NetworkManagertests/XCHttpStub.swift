//
//  XCHttpStub.swift
//  DeliveryAppTests
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import Foundation
import OHHTTPStubs

class XCHttpStub {

    static func request(path: String, responseFile: String) {
        stub(condition: isHost(path)) { _ in
            let stubPath = FilePath(responseFile).path
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
        }
    }

}

class FilePath {
    var fileName: String

    var path: String {
        let applicationDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        if let filePath = applicationDocumentsDirectory?.appendingPathComponent(fileName),
            FileManager.default.fileExists(atPath: filePath.absoluteString) {
            return filePath.absoluteString
        }
        let bundle = Bundle(for: type(of: self))
        if let filePath = bundle.path(forResource: fileName, ofType: nil),
            FileManager.default.fileExists(atPath: filePath) {
            return filePath
        }
        return fileName
    }

    init(_ fileName: String) {
        self.fileName = fileName
    }
}
