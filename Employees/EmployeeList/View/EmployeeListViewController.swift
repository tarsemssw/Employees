//
//  EmployeeListViewController.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import UIKit

protocol EmployeeListPresenting {
    func viewDidLoad()
    func refresh()
}

class EmployeeListViewController: UIViewController {
    
    // MARK: Private enums
    
    private enum Constant{
        static let cellIdentifier = "EmployeeListCell"
        static let refreshing = "Fetching..."
    }
    
    
    // MARK: Properties
    
    var presenter: EmployeeListPresenting!
    var refreshControl: UIRefreshControl!
    
    // MARK: Private
    
    private var cellItems: [EmployeeCellItem] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDatalabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!{
        didSet{
            indicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.register(UINib(nibName: Constant.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier)
            
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        initUIRefreshControl()
    }
    func initUIRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constant.refreshing)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: Any) {
        presenter.refresh()
    }
}

// MARK: Conformance

// MARK: UITableViewDataSource

extension EmployeeListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath) as! EmployeeListCell
        cell.configure(cellItem: cellItems[indexPath.row])
        return cell
    }
}

// MARK: EmployeeListPresenting

extension EmployeeListViewController: EmployeeListDisplaying{
    func showIndicator(_ shouldShow: Bool) {
        shouldShow ? indicator.startAnimating() : indicator.stopAnimating()
        if !shouldShow && refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func showNoDataView(with message: String) {
        tableView.isHidden = true
        noDataView.isHidden = false
        self.noDatalabel.text = message
    }
    
    func show(list: [EmployeeCellItem]) {
        tableView.isHidden = false
        noDataView.isHidden = true
        cellItems = list
    }
    
    func show(screenTitle: String) {
        self.title = screenTitle
    }
}

