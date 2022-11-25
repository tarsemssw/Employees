//
//  EmployeeListPresenterTests.swift
//  EmployeesTests
//
//  Created by Tarsem Singh on 25/11/22.
//

import XCTest
@testable import Employees

class EmployeeListPresenterTests: XCTestCase {
    
    var mockAPIClient: MockAPIClient!
    var mockImageLoader: MockImageLoader!
    var mockDisplay: MockEmployeeListDisplay!
    var mockCoordinator: MockEmployeeListCoordinator!
    var presenter: EmployeeListPresenter!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDisplay = MockEmployeeListDisplay()
        mockCoordinator = MockEmployeeListCoordinator()
        mockAPIClient = MockAPIClient()
        mockImageLoader = MockImageLoader()
        presenter = EmployeeListPresenter(
            display: mockDisplay,
            coordinator: mockCoordinator,
            apiClient: mockAPIClient,
            imageLoader: mockImageLoader
        )
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        presenter = nil
        mockDisplay = nil
        mockCoordinator = nil
        mockAPIClient = nil
    }
    
    // MARK:- Tests
    
    func testViewDidLoad() throws {
        // When
        presenter.viewDidLoad()
        
        //Then
        XCTAssertEqual(mockDisplay.showScreenTitleCount, 1)
        XCTAssertEqual(mockDisplay.showScreenTitle, "Employees")
        
        XCTAssertEqual(mockDisplay.showIndicatorCount, 1)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, true)
        
        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)
        XCTAssertTrue(mockAPIClient.fetchDecodedDataCompletionHandler is ((Result<APIResponse, APIError>) -> ()))
    }
    
    func testFetchEmployeeListSuccess() throws {
        // Given
        let employeeList = APIResponse(employees: [Employee(
            uuid: "0d8fcc12-4d0c-425c-8355-390b312b909c",
            full_name: "Justine Mason",
            phone_number: "5553280123",
            email_address: "jmason.demo@squareup.com",
            biography: "Engineer on the Point of Sale team.",
            photo_url_small: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
            photo_url_large: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
            team: "Point of Sale",
            employee_type: "FULL_TIME"
        )])
        
        
        //When
        presenter.viewDidLoad()
        let handler = (mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ()))
        handler?(.success(employeeList))
        
        //Then
        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)
        
        XCTAssertEqual(mockDisplay.showIndicatorCount, 2)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, false)
        
        XCTAssertEqual(mockDisplay.showListCount, 1)
        XCTAssertEqual(mockDisplay.showList?.count, 1)
        XCTAssertEqual(mockDisplay.showList?[0].employee.full_name, "Justine Mason")
        XCTAssertEqual(mockDisplay.showList?[0].employee.uuid, "0d8fcc12-4d0c-425c-8355-390b312b909c")
        
        // When
        let cellItem = mockDisplay.showList?[0]
        cellItem?.loadImage(handler: { _ in })
        
        // Then
        XCTAssertEqual(mockImageLoader.loadCallCount, 1)
        XCTAssertEqual(mockImageLoader.loadURLPath, "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg")
    }
    
    func testLoadImage() throws {
        // Given
        let employeeList = APIResponse(employees: [Employee(
            uuid: "0d8fcc12-4d0c-425c-8355-390b312b909c",
            full_name: "Justine Mason",
            phone_number: "5553280123",
            email_address: "jmason.demo@squareup.com",
            biography: "Engineer on the Point of Sale team.",
            photo_url_small: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
            photo_url_large: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
            team: "Point of Sale",
            employee_type: "FULL_TIME"
        )])
        presenter.viewDidLoad()
        let handler = (mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ()))
        handler?(.success(employeeList))
        let cellItem = mockDisplay.showList?[0]
        var receivedImage: UIImage?
        cellItem?.loadImage(handler: { (image) in
            receivedImage = image
        })
        
        // When
        let imageData = #imageLiteral(resourceName: "placeholder")
        mockImageLoader.loadCompletionHandler?(imageData)
        
        // Then
        XCTAssertEqual(receivedImage?.pngData(), imageData.pngData())
    }
    
    func testCancelImage() throws {
        // Given
        let employeeList = APIResponse(employees: [Employee(
            uuid: "0d8fcc12-4d0c-425c-8355-390b312b909c",
            full_name: "Justine Mason",
            phone_number: "5553280123",
            email_address: "jmason.demo@squareup.com",
            biography: "Engineer on the Point of Sale team.",
            photo_url_small: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
            photo_url_large: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
            team: "Point of Sale",
            employee_type: "FULL_TIME"
        )])
        presenter.viewDidLoad()
        let handler = (mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ()))
        handler?(.success(employeeList))
        
        // When
        let cellItem = mockDisplay.showList?[0]
        cellItem?.cancel()
        
        // Then
        XCTAssertEqual(mockImageLoader.cancelCallCount, 1)
        XCTAssertEqual(mockImageLoader.cancelURLPath, "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg")
    }
    
    func testFetchEmployeeListSuccessEmptyList() throws {
        // Given
        let employeeList: APIResponse = APIResponse(employees: [])
        
        //When
        presenter.viewDidLoad()
        let handler = mockAPIClient.fetchDecodedDataCompletionHandler as! ((Result<APIResponse, APIError>) -> ())
        handler(.success(employeeList))
        
        //Then
        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)
        
        XCTAssertEqual(mockDisplay.showIndicatorCount, 2)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, false)
        
        XCTAssertEqual(mockDisplay.showNoDataViewCount, 1)
        XCTAssertEqual(mockDisplay.showNoDataViewMessage, "Sorry! \n\n Could not find any employees. Please try again later.")
    }
    
    func testFetchEmployeeListFailure() throws {
        //When
        presenter.viewDidLoad()
        let handler = mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ())
        handler?(.failure(APIError.response))
        
        //Then
        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)
        
        XCTAssertEqual(mockDisplay.showIndicatorCount, 2)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, false)
        
        XCTAssertEqual(mockDisplay.showNoDataViewCount, 1)
        XCTAssertEqual(mockDisplay.showNoDataViewMessage, "Oops! \n\n There is some issue in loading employees. Please try again later.")
    }
}

// MARK:- Mocks

final class MockEmployeeListDisplay: EmployeeListDisplaying {
    
    private(set) var showScreenTitleCount = 0
    private(set) var showScreenTitle: String?
    
    private(set) var showIndicatorCount = 0
    private(set) var shouldShowIndicator: Bool?
    
    private(set) var showNoDataViewCount = 0
    private(set) var showNoDataViewMessage: String?
    
    private(set) var showListCount = 0
    private(set) var showList: [EmployeeCellItem]?
    
    func show(screenTitle: String) {
        showScreenTitleCount += 1
        showScreenTitle = screenTitle
    }
    
    func showIndicator(_ shouldShow: Bool) {
        showIndicatorCount += 1
        shouldShowIndicator = shouldShow
    }
    
    func showNoDataView(with message: String) {
        showNoDataViewCount += 1
        showNoDataViewMessage = message
    }
    
    func show(list: [EmployeeCellItem]) {
        showListCount += 1
        showList = list
    }
}
final class MockEmployeeListCoordinator: EmployeeListCoordinating {
    
}

final class MockImageLoader: ImageLoading{
    private(set) var loadCallCount: Int = 0
    private(set) var loadURLPath: String?
    private(set) var loadCompletionHandler: ((UIImage) -> Void)?
    
    private(set) var cancelCallCount: Int = 0
    private(set) var cancelURLPath: String?
    
    func load(urlPath: String, completionHandler: @escaping ((UIImage?) -> Void)) {
        loadCallCount += 1
        loadURLPath = urlPath
        loadCompletionHandler = completionHandler
    }
    
    func cancel(urlPath: String) {
        cancelCallCount += 1
        cancelURLPath = urlPath
    }
}

