//
//  ImageLoader.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

protocol ImageLoading {
    func load(urlPath: String, completionHandler: @escaping ((UIImage?) -> Void))
    func cancel(urlPath: String)
}

final class ImageLoader: ImageLoading{
    
    // MARK: Properties
    
    private var apiClient: APIClient
    private var fileIOManager = try? FileIOManager()
    private var ongoingTasks: [String : URLSessionDownloadTask] = [:]
    
    // MARK: Initializer
    
    init(apiClient: APIClient = APIClientImplementation())  {
        self.apiClient = apiClient
    }
    
    
    // MARK: Methods
    
    func load(urlPath: String, completionHandler: @escaping ((UIImage?) -> Void)){
        getImageFromCache(urlPath: urlPath, completionHandler: completionHandler)
    }
    
    func cancel(urlPath: String){
        if let cancellableTask = ongoingTasks[urlPath]{
            cancellableTask.cancel()
            ongoingTasks.removeValue(forKey: urlPath)
        }
    }
}
extension ImageLoader{
    func getImageFromCache(urlPath:String, completionHandler: @escaping ((UIImage?) -> Void)){
        let fileName = getFileNameFromUrl(url: urlPath)
        if let file = try? fileIOManager?.read(documentName: fileName){
            let image = UIImage(contentsOfFile: file.relativePath)
            completionHandler(image)
        }else{
            downloadImage(urlPath: urlPath, completionHandler: completionHandler)
        }
    }
    func downloadImage(urlPath: String, completionHandler: @escaping ((UIImage?) -> Void)){
        let downloadTask = apiClient.downloadImageWithUrl(urlPath) {[weak self] result in
            self? .ongoingTasks.removeValue(forKey: urlPath)
            switch result{
            case .success(let tmpLocation):
                self?.handleSuccess(fromUrl: tmpLocation, toUrl: urlPath, completionHandler: completionHandler)
            case .failure(_):
                break
            }
        }
        ongoingTasks[urlPath] = downloadTask
        downloadTask?.resume()
    }
    
    func handleSuccess(fromUrl: URL, toUrl: String, completionHandler: @escaping ((UIImage?) -> Void)){
        // move the downloaded file from the temporary location url to your app documents directory
        let fileName = getFileNameFromUrl(url: toUrl)
        if let file = try? fileIOManager?.move(fromURL: fromUrl, documentName: fileName){
            let image = UIImage(contentsOfFile: file.relativePath)
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }else{
            completionHandler(nil)
        }
    }
    func getFileNameFromUrl(url:String) -> String{
        guard let pathComponents = URL(string: url)?.pathComponents else{return "default.jpg"}
        if pathComponents.count > 2{
            return "\(pathComponents[pathComponents.count-2])-\(pathComponents[pathComponents.count-1])"
        }
        return "default.jpg"
    }
    
}
