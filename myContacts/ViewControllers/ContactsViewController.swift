//
//  ViewController.swift
//  easy-delete
//
//  Created by Marcos Vicente on 28.07.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class ContactsViewController: BaseViewController {

//    MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func manageOnTouchUpInside(_ sender: Any) {
        
    }
    
    
//    MARK: - PROPERTIES
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    let myRefreshControl: UIRefreshControl = UIRefreshControl()
    
    var managing: Bool = false
    var timer: Timer?
    
    
//    MARK: - METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        tableView.isEditing = false
    }
    
    
    func setupNavigationBar() {
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        
        setupSearchController()
        setupRefreshControl()
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        
    }
    
}

