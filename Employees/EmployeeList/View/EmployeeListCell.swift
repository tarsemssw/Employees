//
//  EmployeeListCell.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

class EmployeeListCell: UITableViewCell {
    
    // MARK: Properties
    
    weak var cellItem: EmployeeCellItem?
    
    // MARK: Outlets
    
    @IBOutlet weak var employeeImageView: UIImageView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeTeam: UILabel!
    
    @IBOutlet weak var employeeType: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellItem?.cancel()
    }
    
    // MARK: Methods

    func configure(cellItem: EmployeeCellItem){
        self.cellItem = cellItem
        employeeName.text = cellItem.employee.full_name
        employeeTeam.text = cellItem.employee.team
        employeeType.text = cellItem.employee.employee_type
        
        cellItem.loadImage {[weak self] image in
            self?.employeeImageView.image = image
        }
    }
    
}

