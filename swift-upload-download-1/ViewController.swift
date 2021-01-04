//
//  ViewController.swift
//  swift-upload-download-1
//
//  Created by user926078 on 1/3/21.
//

import UIKit

class ViewController: UIViewController {
    var file: File? = nil;
    
    // Get documents directory
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // Returns documents path + file name
    func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    let downloadService = DownloadService()
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).download")
        // Download can be scheduled by system for optimal performance
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

    //
    // MARK: - IBAction implementation
    //
    @IBAction func onUploadClicked(_ sender: Any) {
        self.output.text = ""

        let file = File(link: "https://file.io",data: "text=this is the file content");
        uploadService.start(file: file)
    }
    
    @IBAction func onDownloadClicked(_ sender: Any) {  
        self.output.text = ""
        
        guard self.file != nil else {
            output.text = "File is nil. Upload a file first"
            return
        }
        
        downloadService.start(file: file!)
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
    
    do {
        let text = try String(contentsOf: targetPath, encoding: .utf8)
        print(text)
        self.output.text = "File download complete. File content:\n"+text
    }
    catch {
        print("Error reading file")
    }
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
        
        // Convert to JSON
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            self.file = File(success: jsonResult!["success"] as! Bool, key: jsonResult!["key"] as! String, link: jsonResult!["link"] as! String, expiry: jsonResult!["expiry"] as! String)
        }
        catch {
            print("Error converting server response to json")
        }
        
        // Print to UI
        if let responseText = String(data: data, encoding: .utf8) {
            print(responseText)
            self.output.text = "Upload server response:\n"+responseText
            
        }
    }
}
