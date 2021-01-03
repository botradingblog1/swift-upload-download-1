//
//  Content.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

struct Content: Codable {
    let content: String
    
    init(content: String) {
        self.content = content
    }
}

