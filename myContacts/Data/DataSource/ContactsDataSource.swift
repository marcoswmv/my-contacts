//
//  ContactsDataSource.swift
//  myContacts
//
//  Created by Marcos Vicente on 06.08.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift

class ContactsDataSource: BaseDataSource {
    
    private(set) var data: [[Contact]]?
    private var filteredData: [[Contact]]?
    private var sectionTitles: [String] = [String]()
    private var filteredSectionTitles: [String] = [String]()
    private var isSearching: Bool = false
    
    override func setup() {
        super.setup()
    }
    
    override func reload() {
        onLoading!(true)
        
        DataBaseManager.shared.fetchContacts { (result, error) in
            self.onLoading!(false)
            if error != nil {
                self.onError?(error!)
            } else {
                self.isSearching = false
                self.populateData(from: result)
                self.tableView.reloadData()
            }
        }
        
//        Refactor this peace of code in the future because i'm not
//        sure if it's a good practice to call twice the "populateData()" method in the same function.
//        NOTE: This solved the problem of updating the table with new contact on launch and on pull to refresh.
        DataBaseManager.shared.dataChanged = {
            let result = DataBaseManager.shared.getContacts()
            self.populateData(from: result)
            self.tableView.reloadData()
        }
    }
    
    func startQuery(with text: String) {
        isSearching = !text.isEmpty ? true : false
        let queryResult = DataBaseManager.shared.filterContacts(from: text, in: false)
        populateData(from: queryResult, isSearching: true)
        tableView.reloadData()
    }
    
    
//    MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            TO-DO:
//            1 - Delete it from user's contacts - done
//            2 - Set the contact as deleted in database - done
//            3 - Update the data source - done
//            4 - Verify if everything is working as expected
            
            let contactToDeleteID = data![indexPath.section][indexPath.row].contactID
            ContactStoreManager.shared.deleteContact(with: contactToDeleteID)
            tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return nil
        } else {
            return sectionTitles[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearching {
            if filteredSectionTitles.isEmpty {
                return nil
            } else {
                return filteredSectionTitles
            }
        } else {
            return sectionTitles
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return filteredSectionTitles.isEmpty ? 1 : filteredSectionTitles.count
        } else {
            return sectionTitles.isEmpty ? 1 : sectionTitles.count
        }
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
            return filteredData?[section].count ?? 0
        } else {
            return data?[section].count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        if isSearching {
            cell.data = filteredData![indexPath.section][indexPath.row]
        } else {
            cell.data = data![indexPath.section][indexPath.row]
        }
        
        return cell
    }
    
//    MARK: - Helper methods

    fileprivate func generateSectionTitles(from contacts: Results<Contact>, isSearching: Bool) {

        for contact in contacts {
            let letter = String(contact.firstName.prefix(1))
            if isSearching {
                if !filteredSectionTitles.contains(letter) {
                    filteredSectionTitles.append(letter)
                }
            } else {
                if !sectionTitles.contains(letter) {
                    sectionTitles.append(letter)
                }
            }
        }
    }
    
    fileprivate func groupContactsInData(by sectionTitles: [String], _ contacts: Results<Contact>) -> [[Contact]] {
        var result: [[Contact]] = [[Contact]]()
        
        for letter in sectionTitles {
            var section = [Contact]()
            for contact in contacts {
                if contact.firstName.prefix(1).contains(letter) {
                    section.append(contact)
                }
            }
            result.append(section)
        }
        return result
    }
    
    fileprivate func populateData(from contacts: Results<Contact>?, isSearching: Bool = false) {
        guard let contacts = contacts else { return }
        generateSectionTitles(from: contacts, isSearching: isSearching)
        
        if isSearching {
            self.filteredData = groupContactsInData(by: filteredSectionTitles, contacts)
        } else {
            self.data = groupContactsInData(by: sectionTitles, contacts)
        }
    }
}
