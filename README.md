# iOS Swift sample app for file uploads and downloads

## Overview
This project is an iOS Swift sample app for file uploads and downloads using URLSession, DownloadTask, DataTask and JSONSerialization.
The mock server side 'http://file.io' is used to upload and download the files.

## Highlights:
* Structuring implementation into model classes and upload and download tasks and services.
* Implementing delegates to receive upload and download events 
* Starting background downloads using URLSession and DownloadTask
* Starting file uploads using URLSession and DataTask
* Deserializing server responses after successful upload
* Saving downloaded files to the documents directory.

## Supporting material
For a step-by-step tutorial, please see my [blog post on implementing iOS uploads and downloads in Swift](https://mobiledeveloperblog.com/file-upload-download-with-swift/).

## Getting Started
1. Cone the project from GitHub

```
	https://github.com/justmobiledev/swift-upload-download-1.git
```
2. Build the project in Xcode
3. Deploy on simulator or device.

## Versions used
* XCode 12.2
* Swift 5
* iOS 12.

## Sample App Usage
1. Press the 'Upload' button to upload a file to file.io.
2. Press the 'Download button to download the file again from file.io.
