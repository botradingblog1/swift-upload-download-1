//
//  DownloadService.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

class DownloadService {
  var downloadSession: URLSession!
  
    func start(_ url: String) {
        let downloadTask = DownloadTask(url: url)

        // Create request
        let request = NSMutableURLRequest(url: downloadTask.url!)
        request.httpMethod = "GET"
        
        // Create download task
        downloadTask.task = downloadSession.downloadTask(with: request as URLRequest)

        downloadTask.task?.resume()
        downloadTask.inProgress = true
    }
}
