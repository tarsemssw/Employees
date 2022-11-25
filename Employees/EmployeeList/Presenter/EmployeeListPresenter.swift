//
//  EmployeeListPresenter.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

protocol EmployeeListDisplaying: AnyObject {
    func showIndicator(_ shouldShow: Bool)
    func show(screenTitle: String)
    func showNoDataView(with message: String)
    func show(list: [Employee])
}
protocol APIClient {
    func fetchDecodedData<T: Decodable>(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<T, APIError>) -> Void)
    func downloadImageWithUrl(_ url: String, _ completionHandler: @escaping (Result<URL, APIError>) -> Void) -> URLSessionDownloadTask?
}

final class EmployeeListPresenter {
    
    // MARK: Enums
    
    // MARK: Private
    
    private enum Constant{
        static let screenTitle = "Employees"
    }
    
    private enum URLPath {
        static let employeeList = "/sq-mobile-interview/employees.json"
        static let emptyList = "/sq-mobile-interview/employees_empty.json"
        static let error = "/sq-mobile-interview/employees_malformed.json"
    }
    
    private enum Message{
        static let emptyView = "Sorry! \n\n Could not find any employees. Please try again later."
        static let error = "Oops! \n\n There is some issue in loading employees. Please try again later."
        static let general = "Something went wrong!"
    }
    
    // MARK: Properties
    
    // MARK: Private
    
    private weak var display: EmployeeListDisplaying?
    private weak var coordinator: EmployeeListCoordinating?
    private var apiClient: APIClient!
    
    
    // MARK: Initialisers
    
    init(display: EmployeeListDisplaying,
         coordinator: EmployeeListCoordinating,
         apiClient: APIClient = APIClientImplementation()
    ){
        self.display = display
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
    // MARK: Methods
    
    // MARK: Private
    
    private func fetchEmployeeList(){
        display?.showIndicator(true)
        apiClient.fetchDecodedData(URLPath.employeeList, queryItems: nil) {[weak self] (result: Result<APIResponse, APIError>) in
            
            defer{
                self?.display?.showIndicator(false)
            }
            
            switch result{
            case .success(let employees):
                self?.handleSuccesss(with: employees.employees)
                break
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    private func handleSuccesss(with employeeList:[Employee]){
        guard employeeList.count > 0 else{
            self.display?.showNoDataView(with: Message.emptyView)
            return
        }
        
        self.display?.show(list: employeeList)
    }
    
    private func handleError(_ error: APIError){
        var errorMessage: String
        switch error {
        case .request:
            errorMessage = Message.general
        case .response:
            errorMessage = Message.error
        }
        
        self.display?.showNoDataView(with: errorMessage)
    }
}

// MARK:- Conformance

// MARK: EmployeeListPresenting

extension EmployeeListPresenter: EmployeeListPresenting{
    func viewDidLoad() {
        display?.show(screenTitle: Constant.screenTitle)
        fetchEmployeeList()
    }
}


