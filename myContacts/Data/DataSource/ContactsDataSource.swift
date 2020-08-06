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
    
    private var manager: DataBaseManager = DataBaseManager()
    
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
        
        manager.fetchContacts { (result, error) in
            
            self.onLoading!(false)
            if error != nil {
                self.onError?(error!)
            } else {
                
            }
        }
    }
    
    fileprivate func startQuery(with text: String) {
        isSearching = !text.isEmpty ? true : false
        let queryResult = manager.filterContacts(from: text, in: false)
        populateData(from: queryResult)
        tableView.reloadData()
    }
    
    
//    MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return filteredSectionTitles[section]
        } else {
            return sectionTitles[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        TO-DO: return index for searching results
        if isSearching {
            return filteredSectionTitles
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
        if isSearching {
            if filteredData?.count == 0 {
                addTableViewBackgroundView(with: "No Results")
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
    
    fileprivate func populateData(from contacts: Results<Contact>?, isSearching: Bool = false) {
        guard let contacts = contacts else { return }
        generateSectionTitles(from: contacts, isSearching: isSearching)
        
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
        
        if isSearching {
            self.filteredData = result
        } else {
            self.data = result
        }
    }
    
    fileprivate func generateSectionTitles(from contacts: Results<Contact>, isSearching: Bool) {
//        filteredSectionTitles = [String]()
//        sectionTitles = [String]()
            
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
}
