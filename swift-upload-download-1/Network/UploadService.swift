//
//  UploadService.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import Foundation

class UploadService {
  var uploadSession: URLSession!
    
    func start(gist: Gist, url: String) {
        let uploadTask = UploadTask(gist: gist)
        
        // Workaround to handle issue that Gist requires 'public' property, which is a keyword in swift
        /* guard let uploadData = try? JSONEncoder().encode(gist) else {
            return
        }*/
        let uploadData =  Data("{\"public\":true,\"files\":{\"curltest2\":{\"content\":\"this is the content from ios\"}}}".utf8)

        // Create request
        let urlObj = URL(string: url)!;
        
        var request = URLRequest(url: urlObj)
        request.httpMethod = "POST"
        request.setValue("bearer d7dbcb226b248d33fb7a9de4394a3e9be729decb", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
    
        // Create upload task
        uploadTask.task = uploadSession.uploadTask(with: request, from: uploadData)

        uploadTask.task?.resume()
        uploadTask.inProgress = true
        
    }
}
