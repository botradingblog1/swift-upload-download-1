//
//  Gist.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

struct Gist: Codable {
    let files: Content
    
    init(content: Content) {
        self.files = content
   }
}

