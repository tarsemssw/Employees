//
//  ImageLoaderTests.swift
//  EmployeesTests
//
//  Created by Tarsem Singh on 25/11/22.
//

import XCTest
@testable import Employees

class ImageLoaderTests: XCTestCase {
    
    var mockImageLoader: MockImageLoader!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockImageLoader = MockImageLoader()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockImageLoader = nil
    }

    func testLoad() throws {
        // When
        mockImageLoader.load(urlPath: "/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg") { _ in }
        
        // Then
        XCTAssertEqual(mockImageLoader.loadCallCount, 1)
        XCTAssertEqual(mockImageLoader.loadURLPath, "/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg")
    }
    
    func testLoadSuccess() throws {
        // Given
        let mockData = #imageLiteral(resourceName: "placeholder")
        var receivedData: UIImage?
        mockImageLoader.load(urlPath: "/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg") { data in
            receivedData = data
        }
        
        // When
        let completion = mockImageLoader.loadCompletionHandler
        completion?(mockData)
        
        // Then
        XCTAssertEqual(receivedData, mockData)
    }
}
