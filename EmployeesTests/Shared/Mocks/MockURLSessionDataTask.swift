//
//  MockURLSessionDataTask.swift
//  EmployeesTests
//
//  Created by Tarsem Singh on 25/11/22.
//

import XCTest

final class MockURLSessionDataTask: URLSessionDataTask{
    private(set) var resumeCallCount: Int = 0
    private(set) var cancelCallCount: Int = 0
    
    override init() {
    }
    
    override func resume() {
        resumeCallCount += 1
    }
    
    override func cancel() {
        cancelCallCount += 1
    }
}

