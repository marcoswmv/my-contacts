//
//  DeletedContactsDataSource.swift
//  myContacts
//
//  Created by Marcos Vicente on 30.08.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class DeletedContactsDataSource: BaseDataSource {
    
    private(set) var data: Results<Contact>?
    private var filteredData: Results<Contact>?
    private var isSearching: Bool = false
    
    var deleteSelectedContacts: ((_ indexPath: IndexPath) -> Void)?
    
    override func setup() {
        super.setup()
//        TO-DO: After solving the problem down below, I have to implement the day countdown for permanent deletion
//        Problem: Deletion on selection not working as it should, only one contact is being deleted even with more than one selected. I think it's because of this sparggheti code down below
        self.deleteSelectedContacts = { indexPath in
            Alert.showActionSheetToAskForConfirmationToDelete(on: UIApplication.topViewController()!) { (delete) in
                let contactToDelete = self.data![indexPath.row]
                DataBaseManager.shared.delete(contact: contactToDelete)
                self.tableView.reloadData()
            }
        }
    }
    
    override func reload() {
        onLoading!(true)
        
        let result = DataBaseManager.shared.getContacts(wasDeleted: true)
        data = result
        tableView.reloadData()
    }
    
    func startQuery(with text: String) {
        isSearching = !text.isEmpty ? true : false
        let queryResult = DataBaseManager.shared.filterContacts(from: text, wasDeleted: true)
        filteredData = queryResult
        tableView.reloadData()
    }
    
//    MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            Alert.showActionSheetToAskForConfirmationToDelete(on: UIApplication.topViewController()!) { (delete) in
                let contactToDelete = self.data![indexPath.row]
                DataBaseManager.shared.delete(contact: contactToDelete)
                tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        To set back the table view background to it's default style
        tableView.backgroundView = UIView()
        tableView.separatorStyle = .singleLine
        
        if isSearching {
            if filteredData?.count == 0 {
                addTableViewBackgroundView(with: "No Results")
                return 0
            }
            return filteredData?.count ?? 0
        } else {
            return data?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeletedContactCell", for: indexPath) as! DeletedContactCell
        
        if isSearching {
            cell.data = filteredData![indexPath.row]
        } else {
            cell.data = data![indexPath.row]
        }
        
        return cell
    }
}
