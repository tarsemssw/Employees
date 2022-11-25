//
//  APIClientTests.swift
//  EmployeesTests
//
//  Created by Tarsem Singh on 25/11/22.
//

import XCTest
@testable import Employees

class APIClientTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var apiClient: APIClientImplementation!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockURLSession = MockURLSession()
        apiClient = APIClientImplementation(session: mockURLSession)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiClient = nil
        mockURLSession = nil
    }
    
    // MARK: Tests
    
    func testFetchDecodedData() throws {
        // When
        apiClient.fetchDecodedData("/sq-mobile-interview/employees.json", queryItems: nil) {(result: Result<APIResponse, APIError>) in }
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://s3.amazonaws.com/sq-mobile-interview/employees.json")
    }
    
    func testFetchDecodedDataSuccess() throws {
        // Given
        let mockData = mockJsonString.data(using: .utf8)
        var receivedData: APIResponse?
        let testExpectation = expectation(description: #function)
        
        // When
        apiClient.fetchDecodedData("/sq-mobile-interview/employees.json", queryItems: nil) {(result: Result<APIResponse, APIError>) in
            switch result{
            case .success(let employeeList):
                receivedData = employeeList
            default:
                break
            }
            testExpectation.fulfill()
        }
        mockURLSession.completionHandler?(mockData, nil)
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://s3.amazonaws.com/sq-mobile-interview/employees.json")        
    }
    
    func testFetchDecodedDataFailure() throws {
        // Given
        var receivedError: APIError?
        let testExpectation = expectation(description: #function)
        
        // When
        apiClient.fetchDecodedData("/sq-mobile-interview/employees_malformed.json", queryItems: nil) {(result: Result<APIResponse, APIError>) in
            switch result{
            case .failure(let error):
                receivedError = error
            default:
                break
            }
            testExpectation.fulfill()
        }
        mockURLSession.completionHandler?(nil, MockError())
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json")
        XCTAssertEqual(receivedError, APIError.response)
    }
}

// MARK: Mocks

final class MockURLSession: URLSessionProtocol{
    private(set) var loadDataCallCount = 0
    private(set) var url: URL?
    private(set) var completionHandler: ((Data?, Error?) -> Void)?
    
    private(set) var imageDownloadCallCount = 0
    private(set) var imageDownloadUrl: URL?
    private(set) var imageDownloadCompletionHandler: ((URL?, Error?) -> Void)?
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        loadDataCallCount += 1
        self.url = url
        self.completionHandler = completionHandler
        return MockURLSessionDataTask()
    }
    func downloadImage(from url: URL, completionHandler: @escaping (URL?, Error?) -> Void) -> URLSessionDownloadTask {
        imageDownloadCallCount += 1
        self.imageDownloadUrl = url
        self.imageDownloadCompletionHandler = completionHandler
        return MockURLSessionDownloadTask()
    }
}

final class MockError: Error{
}

private var mockJsonString = """
{
    "employees": [
        {
            "uuid": "0d8fcc12-4d0c-425c-8355-390b312b909c",
            "full_name": "Justine Mason",
            "phone_number": "5553280123",
            "email_address": "jmason.demo@squareup.com",
            "biography": "Engineer on the Point of Sale team.",
            "photo_url_small": "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
            "photo_url_large": "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
            "team": "Point of Sale",
            "employee_type": "FULL_TIME"
        }
    ]
}
"""

