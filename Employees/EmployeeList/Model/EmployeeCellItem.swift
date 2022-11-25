//
//  EmployeeCellItem.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

protocol CellItemNotifier: AnyObject {
    func loadImage(url:String, cellItem: EmployeeCellItem)
}


final class EmployeeCellItem {
    
    // MARK: Properties
    
    var employee: Employee
    
    var loadImageNotifier: ((String, @escaping ((UIImage) -> Void)) -> Void)?
    var cancelImageNotifier: ((String) -> Void)?
    private var imageHandler: ((UIImage) -> Void)?
    
    
    
    // MARK: Initialisers
    
    init(employee: Employee) {
        self.employee = employee
    }
    
    // MARK: Methods
    
    func loadImage(handler: @escaping (UIImage) -> Void){
        imageHandler = handler
        handler(#imageLiteral(resourceName: "placeholder"))
        guard let imageURL = self.employee.photo_url_small else {
            return
        }
        
        loadImageNotifier?(imageURL){[weak self] image in
            self?.imageHandler?(image)
        }
    }
    
    func cancel(){
        if let imageURL = self.employee.photo_url_small {
            cancelImageNotifier?(imageURL)
            imageHandler = nil
        }
    }
}


