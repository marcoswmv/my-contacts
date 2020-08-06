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
    
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private let myRefreshControl: UIRefreshControl = UIRefreshControl()
    
    private var managing: Bool = false
    private var timer: Timer?
    
    
//    MARK: - METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        tableView.isEditing = false
    }
    
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        
        setupSearchController()
        setupRefreshControl()
    }
    
    fileprivate func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    fileprivate func setupRefreshControl() {
        tableView.refreshControl = myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        
    }
    
}

