//
//  DownloadTask.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

class DownloadTask {
  var file: File
  var url: URL?
  var inProgress = false
  var resumeData: Data?
  var task: URLSessionDownloadTask?

  init(file: File) {
    self.file = file
    self.url = URL(string: file.link)
  }
}

