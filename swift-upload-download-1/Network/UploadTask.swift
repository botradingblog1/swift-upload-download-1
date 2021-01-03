//
//  UploadTask.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

class UploadTask {
  var gist: Gist
  var inProgress = false
  var task: URLSessionUploadTask?

  init(gist: Gist) {
    self.gist = gist
  }
}
