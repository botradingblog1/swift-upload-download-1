//
//  DownloadService.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

class DownloadService {
  var downloadSession: URLSession!
  
    func start(file: File) {
        let downloadTask = DownloadTask(file: file)

        // Create request
        let request = NSMutableURLRequest(url: downloadTask.url!)
        request.httpMethod = "GET"
        
        // Create download task
        downloadTask.task = downloadSession.downloadTask(with: request as URLRequest)

        // Start download
        downloadTask.task?.resume()
        downloadTask.inProgress = true
    }
}
