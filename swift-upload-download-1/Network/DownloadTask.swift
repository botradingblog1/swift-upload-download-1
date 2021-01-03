//
//  DownloadTask.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

class DownloadTask {
  var url: URL?
  var inProgress = false
  var resumeData: Data?
  var task: URLSessionDownloadTask?

  init(url: String) {
    self.url = URL(string: url)
  }
}

