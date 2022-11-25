//
//  APIClient.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

protocol URLSessionProtocol {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask
    func downloadImage(from url: URL, completionHandler: @escaping (URL?, Error?) -> Void) -> URLSessionDownloadTask
}

extension URLSession: URLSessionProtocol{
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)-> URLSessionDataTask {
        return dataTask(with: url) { (data, _, error) in
            completionHandler(data, error)
        }
    }
    func downloadImage(from url: URL, completionHandler: @escaping (URL?, Error?) -> Void) -> URLSessionDownloadTask {
        return downloadTask(with: url) { location, _ , error in
            completionHandler(location, error)
        }
    }
}

final class APIClientImplementation: APIClient{
    
    // MARK: Enums
    private enum Components {
        static let scheme = "https"
        static let host = "s3.amazonaws.com"
    }
    
    // MARK: Properties
    
    // MARK: Private
    
    private var session: URLSessionProtocol!
    private var urlComponents = URLComponents()
    
    // MARK: Initialisers
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        urlComponents.scheme = Components.scheme
        urlComponents.host = Components.host
    }
    
    // MARK: Methods
    
    func fetchDecodedData<T: Decodable>(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<T, APIError>) -> Void){
        fetchData(urlPath,queryItems: queryItems) { (result) in
            switch result{
            case .success(let data):
                guard let response =  try? JSONDecoder().decode(T.self, from: data) else {
                    return completionHandler(.failure(APIError.response))
                }
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }?.resume()
    }
    
    private func fetchData(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?{
        urlComponents.path = urlPath
        if let queryItems = queryItems{
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            completionHandler(.failure(APIError.request))
            return nil
        }
        return fetchDataWithUrl(url.absoluteString, completionHandler)
    }
    private func fetchDataWithUrl(_ url: String, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?{
        
        guard let url = URL(string: url)else{
            completionHandler(.failure(APIError.request))
            return nil
        }
        
        return session.loadData(from: url) { data, error in
            let result:Result<Data, APIError> = self.getResult(data: data, error: error)
            DispatchQueue.main.async { completionHandler(result) }
        }
    }
    
    func downloadImageWithUrl(_ url: String, _ completionHandler: @escaping(Result<URL, APIError>) -> Void) -> URLSessionDownloadTask?{
        
        guard let url = URL(string: url)else{
            completionHandler(.failure(APIError.request))
            return nil
        }
        
        return session.downloadImage(from: url) { location, error in
            let result:Result<URL, APIError> = self.getImageLocationResult(location: location, error: error)
            completionHandler(result)
        }
    }
    
    private func getResult(data: Data?, error: Error?) -> Result<Data, APIError>{
        guard let data = data else {
            return .failure(APIError.response)
        }
        return .success(data)
    }
    private func getImageLocationResult(location: URL?, error: Error?) -> Result<URL, APIError>{
        guard let location = location else {
            return .failure(APIError.response)
        }
        return .success(location)
    }
}

enum APIError: Error{
    case request
    case response
}
