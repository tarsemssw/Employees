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
    
    
    // MARK: Initialisers
    
    init(display: EmployeeListDisplaying,
         coordinator: EmployeeListCoordinating
    ){
        self.display = display
        self.coordinator = coordinator
    }
    
    // MARK: Methods
    
    // MARK: Private
    
    private func fetchEmployeeList(){
        display?.showIndicator(true)
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


