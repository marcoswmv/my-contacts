//
//  DataBaseManager.swift
//  myContacts
//
//  Created by Marcos Vicente on 02.08.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import Foundation
import Contacts
import RealmSwift

public class DataBaseManager {
    
    typealias ContactsFetchingCompletionHandler = (_ contact: Results<Contact>?, _ error: Error?) -> Void
    
    private let realm = try! Realm()
    private var contactStoreManager: ContactStoreManager = ContactStoreManager()
    
    func fetchContacts(completionHandler: @escaping ContactsFetchingCompletionHandler) {
        
        contactStoreManager.fetchContacts { (contact, error) in
            if error != nil {
                
                completionHandler(nil, error)
            } else {
                
                guard let contact = contact else { return }
                DispatchQueue(label: "background").async {
                    
                    let realm = try! Realm()
                    try! realm.write({
                        realm.add(contact, update: .modified)
                    })
                }
            }
        }
    }
    
    func filterContacts(from searchTerm: String, in deleted: Bool) -> Results<Contact> {
        let predicate = NSPredicate(format: "firstName CONTAINS %@ AND wasDeleted = %@", argumentArray: [searchTerm, deleted])
        return realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "firstName", ascending: true)
    }
}
