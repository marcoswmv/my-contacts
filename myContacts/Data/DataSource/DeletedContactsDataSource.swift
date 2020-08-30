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
        
        self.deleteSelectedContacts = { indexPath in
            
//            let contactToDeleteID = self.data![indexPath.section][indexPath.row].contactID
//            ContactStoreManager.shared.deleteContact(with: contactToDeleteID)
//            DataBaseManager.shared.setAsDeletedContact(with: contactToDeleteID)
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
            
//            TO-DO: Show alert asking the user if he's sure about the action, because it's going to permanently delete the contact
            
//            let contactToDeleteID = data![indexPath.row].contactID
//            ContactStoreManager.shared.deleteContact(with: contactToDeleteID)
//            DataBaseManager.shared.setAsDeletedContact(with: contactToDeleteID)
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
            print(data)
            cell.data = data![indexPath.row]
        }
        
        return cell
    }
}
