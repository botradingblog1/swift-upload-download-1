//
//  ViewController.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import UIKit

class ViewController: UIViewController {
    
    // Get documents directory
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // Returns documents path + file name
    func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    let downloadService = DownloadService()
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).download")
        // download can be scheduled by system for optimal performance
        //configuration.isDiscretionary = false
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    let uploadService = UploadService()
    lazy var uploadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the URLSession on the download service
        downloadService.downloadSession = downloadSession
        uploadService.uploadSession = uploadSession
    }

    
    @IBAction func onUploadClicked(_ sender: Any) {
        let content = Content(content: "example content")
        let gist = Gist(content: content)
        uploadService.start(gist: gist, url: "https://api.github.com/gists");
    }
    
    @IBAction func onDownloadClicked(_ sender: Any) {  
        downloadService.start("https://api.github.com/gists/396a56e2e4f0330b9fd1d69ace8fb180")
    }
    
    @IBOutlet weak var output: UILabel!
}

//
// MARK: - URL Session Delegate
//
extension ViewController: URLSessionDelegate {
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let completionHandler = appDelegate.backgroundSessionCompletionHandler {
        appDelegate.backgroundSessionCompletionHandler = nil
        completionHandler()
      }
    }
  }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            print("Progress \(downloadTask) \(progress)")
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("did become invalid with error: \(error?.localizedDescription ?? "")");
    }
}



//
// MARK: - URL Session Download Delegate
//
extension ViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {

    guard let sourceURL = downloadTask.originalRequest?.url else {
      return
    }
    
    // Create target path
    let targetPath = localFilePath(for: sourceURL)
    print(targetPath)
    print(location)
    
    // First, remove file in case it was previously downloaded
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: targetPath)
    
    // Write file to target location
    do {
      try fileManager.copyItem(at: location, to: targetPath)
    } catch let error {
      print("Error copying file to disk: \(error.localizedDescription)")
    }
    
    // todo: UI updates
    self.output.text = "download complete"
    
    do {
        let text = try String(contentsOf: targetPath, encoding: .utf8)
        print(text)
    }
    catch {/* error handling here */}

  }
}

//
// MARK: - URL Session Data Delegate
//
extension ViewController: URLSessionDataDelegate {

    // Error received
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let err = error {
            print("Error: \(err.localizedDescription)")
            self.output.text = "Error: \(err.localizedDescription)"
        }
    }

    // Response received
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        print("didReceive response")
    self.output.text = "didReceive response"
        completionHandler(URLSession.ResponseDisposition.allow)
    }

    // Data received
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("didReceive data")
        if let responseText = String(data: data, encoding: .utf8) {
            print("\nServer's response text")
            print(responseText)
            self.output.text = responseText
        }
    }
}
