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

public struct DataBaseManager {
    
///    Singleton. This was created in order to avoid more than one object of type DataBaseManager being created.
///    The init is declared to prevent the struct's memberwise/parenthesys "()" from appearing
///    and is private to avoid the init to be called with dot notation
    static let shared = DataBaseManager()
    private init() { }
    
    typealias ContactsFetchingCompletionHandler = (_ contact: Results<Contact>?, _ error: Error?) -> Void
    
    private let realm = try! Realm()
    
    func fetchContacts(completionHandler: @escaping ContactsFetchingCompletionHandler) {
        
        ContactStoreManager.shared.fetchContacts { (contact, error) in
            
            if error != nil {
                
                completionHandler(nil, error)
            } else {
                
                guard let contact = contact else { return }
                let realm = try! Realm()
                try! realm.write({
                    realm.add(contact, update: .modified)
                })
            }
        }
        
        let contacts = realm.objects(Contact.self).filter("wasDeleted = false").sorted(byKeyPath: "firstName", ascending: true)
        if !contacts.isEmpty {
            completionHandler(contacts, nil)
        }
    }
    
    func delete(contact: Contact) {
        try! realm.write {
            realm.delete(contact)
        }
    }
    
    func getContacts() -> [Contact] {
        let result = realm.objects(Contact.self)
        
        var contacts = [Contact]()
        result.forEach { contacts.append($0) }
        return contacts
    }
    
    func filterContacts(from searchTerm: String, in deleted: Bool) -> Results<Contact> {
        let predicate = NSPredicate(format: "firstName CONTAINS %@ AND wasDeleted = %@", argumentArray: [searchTerm, deleted])
        return realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "firstName", ascending: true)
    }
}
