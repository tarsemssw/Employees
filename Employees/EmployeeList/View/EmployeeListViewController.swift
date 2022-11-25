//
//  EmployeeListViewController.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

protocol EmployeeListPresenting {
    func viewDidLoad()
}

class EmployeeListViewController: UIViewController {
    
    
    // MARK: Properties
    
    var presenter: EmployeeListPresenting!
    
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDatalabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!{
        didSet{
            indicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

// MARK: Conformance

// MARK: EmployeeListPresenting

extension EmployeeListViewController: EmployeeListDisplaying{
    func showIndicator(_ shouldShow: Bool) {
        shouldShow ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    func showNoDataView(with message: String) {
        tableView.isHidden = true
        noDataView.isHidden = false
        self.noDatalabel.text = message
    }
    
    func show(list: [Employee]) {
        tableView.isHidden = false
        noDataView.isHidden = true
    }
    
    func show(screenTitle: String) {
        self.title = screenTitle
    }
}

