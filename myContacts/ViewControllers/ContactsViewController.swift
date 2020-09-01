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
        handleManage()
    }
    
    
//    MARK: - PROPERTIES
    
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private let myRefreshControl: UIRefreshControl = UIRefreshControl()
    private var isManaging: Bool = false
    
    var dataSource: ContactsDataSource?
    var shouldBeginEditing: Bool = true
    var timer: Timer?
    
    
//    MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        setupNavigationBar()
        setupToolbar()
        tableView.isEditing = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isManaging = false
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    
//    MARK: - SETUP AND CONFIGURATION
    
    fileprivate func setupDataSource() {
        dataSource = ContactsDataSource(tableView: tableView)
        dataSource?.onLoading = { [weak self] (isLoading) in
//            TO-DO: Implement loading animation
//            self.displayLoading(loading: isLoading)
        }
        dataSource?.onError = { [weak self] (error) in
            Alert.showErrorAlert(on: self!, message: error.localizedDescription)
        }
        dataSource?.reload()
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
    
    fileprivate func setupToolbar() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        let selectButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(handleSelect))
        
        if !(toolbarItems?.isEmpty ?? true) {
            toolbarItems?.removeAll()
        }

        toolbarItems = [addButton, flexibleSpace, selectButton]
    }
    
    fileprivate func setupToolbarForDeletion() {
        if !toolbarItems!.isEmpty {
            toolbarItems?.removeAll()
        }
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        let deleteButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(handleDelete))

        toolbarItems = [cancelButton, flexibleSpace, deleteButton]
    }
    
    fileprivate func updateUIAfterDeletingSelectedContacts() {
        navigationController?.setToolbarHidden(true, animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
        tableView.setEditing(false, animated: true)
        tableView.isEditing = false
    }
    
    
//    MARK: - HANDLERS
    
    @objc private func handleRefresh() {
        let delay = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.dataSource?.reload()
            self.myRefreshControl.endRefreshing()
        }
    }
    
    @objc private func handleManage() {
        if isManaging {
            isManaging = false
            navigationController?.setToolbarHidden(true, animated: true)
        } else {
            isManaging = true
            navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    @objc private func handleAdd() {
        print("Handling addition")
    }
    
    @objc private func handleSelect() {
        setupToolbarForDeletion()
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        if tableView.isEditing {
            tableView.setEditing(tableView.isEditing, animated: true)
            tableView.isEditing = false
        } else {
            tableView.setEditing(tableView.isEditing, animated: true)
            tableView.isEditing = true
        }
    }
    
    @objc private func handleCancel() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
        tableView.setEditing(false, animated: true)
        tableView.isEditing = false
        setupToolbar()
    }
    
    @objc private func handleDelete() {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths.reversed() {
                dataSource?.deleteSelectedContacts!(indexPath)
            }
            updateUIAfterDeletingSelectedContacts()
            setupToolbar()
        }
    }
    
}

