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
    private var ongoingTasks: [String : URLSessionDownloadTask] = [:]
    
    // MARK: Initializer
    
    init(apiClient: APIClient = APIClientImplementation())  {
        self.apiClient = apiClient
    }
    
    
    // MARK: Methods
    
    func load(urlPath: String, completionHandler: @escaping ((UIImage?) -> Void)){
        downloadImage(urlPath: urlPath, completionHandler: completionHandler)
    }
    
    func cancel(urlPath: String){
        if let cancellableTask = ongoingTasks[urlPath]{
            cancellableTask.cancel()
            ongoingTasks.removeValue(forKey: urlPath)
        }
    }
}
extension ImageLoader{
    func downloadImage(urlPath: String, completionHandler: @escaping ((UIImage?) -> Void)){
        let downloadTask = apiClient.downloadImageWithUrl(urlPath) {[weak self] result in
            self? .ongoingTasks.removeValue(forKey: urlPath)
            switch result{
            case .success(let tmpLocation):
                self?.handleSuccess(location: tmpLocation, completionHandler: completionHandler)
            case .failure(_):
                break
            }
        }
        ongoingTasks[urlPath] = downloadTask
        downloadTask?.resume()
    }
    
    func handleSuccess(location: URL, completionHandler: @escaping ((UIImage?) -> Void)){
        let image = UIImage(contentsOfFile: location.relativePath)
        DispatchQueue.main.async {
            completionHandler(image)
        }
    }
    
}

