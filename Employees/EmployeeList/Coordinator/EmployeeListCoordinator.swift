//
//  EmployeeListCoordinator.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    func start()
}
protocol EmployeeListCoordinating: AnyObject {
    
}

final class EmployeeListCoordinator: Coordinator{
    
    // MARK:- Enums
    
    private enum Identifier{
        static let main = "Main"
        static let employeeListController = "EmployeeListViewController"
    }
    
    // MARK:- Properties
    
    var navigationController: UINavigationController
    
    //MARK:- Initialisers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK:- Methods
    
    func start() {
        let employeeListViewController = UIStoryboard(
            name: Identifier.main,
            bundle:nil).instantiateViewController(
                identifier: Identifier.employeeListController) as EmployeeListViewController
        employeeListViewController.presenter = EmployeeListPresenter(display: employeeListViewController, coordinator: self)
        navigationController.pushViewController(employeeListViewController, animated: false)
    }
}

extension EmployeeListCoordinator : EmployeeListCoordinating{
    
}
