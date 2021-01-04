//
//  File.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/4/21.
//

import Foundation

class File: Codable {
    var success: Bool = false
    var key: String = "";
    var link: String = "";
    var expiry: String = "";
    var data: String = "";
    
    init(link: String, data: String) {
        self.link = link
        self.data = data
    }
    
    init(success: Bool, key: String, link: String, expiry: String) {
        self.success = success
        self.key = key
        self.link = link
        self.expiry = expiry
    }
}
