//
//  MockAPIClient.swift
//  EmployeesTests
//
//  Created by Tarsem Singh on 25/11/22.
//

import XCTest
@testable import Employees

final class MockAPIClient: APIClient {
    
    private(set) var fetchDecodedDataCount = 0
    private(set) var fetchDecodedDataUrl = ""
    private(set) var fetchDecodedDataCompletionHandler: Any?
    
    private(set) var fetchDataCount = 0
    private(set) var fetchDataUrl = ""
    private(set) var fetchDataCompletionHandler: Any?
    
    private(set) var imageDownloadCount = 0
    private(set) var imageDownloadUrl = ""
    private(set) var imageDownloadCompletionHandler: Any?
    
    func fetchDecodedData<T>(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<T, Employees.APIError>) -> Void) where T : Decodable {
        fetchDecodedDataCount += 1
        self.fetchDecodedDataUrl = urlPath
        self.fetchDecodedDataCompletionHandler = completionHandler
    }
    
    func downloadImageWithUrl(_ url: String, _ completionHandler: @escaping (Result<URL, Employees.APIError>) -> Void) -> URLSessionDownloadTask? {
        imageDownloadCount += 1
        self.imageDownloadUrl = url
        self.imageDownloadCompletionHandler = completionHandler
        return MockURLSessionDownloadTask()
    }
}
