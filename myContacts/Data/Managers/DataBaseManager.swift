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
    var token: NotificationToken!
    var dataChanged: ((_ result: Results<Contact>?) -> Void)?
    
///    This singleton was created in order to avoid more than one object of type DataBaseManager being created.
///    The init() is declared to prevent the struct's memberwise/parenthesys "()" from appearing
///    and is private to avoid the init to be called with dot notation
    static let shared = DataBaseManager()
    private init() {
        let realm = try! Realm()
        token = realm.observe { [weak self] (notification, realm) in
            guard let self = self else { return }
            if let change = self.dataChanged {
                change(self.getContacts())
            }
        }
    }
    
    deinit {
        token.invalidate()
    }
    
    func fetchContacts(completionHandler: @escaping ContactsFetchingCompletionHandler) {
        ContactStoreManager.shared.requestContacts { [weak self] (contact, error) in
            guard let self = self else { return }
            if error != nil {
                completionHandler(nil, error)
            } else {
                guard let contact = contact else { return }
                self.update(with: contact)
            }
        }
        
        let contacts = self.getContacts()
        if !contacts.isEmpty {
            completionHandler(contacts, nil)
        }
    }
    
/// This method is used to populate/update the database with data received from Contacts App service
    func update(with contact: Contact) {
        let realm = try! Realm()
        try! realm.write({
            realm.create(Contact.self, value: contact, update: .modified)
        })
    }
    
/// This method is used to permanently delete the contact from the database. And the contact is not restorable anymore.
    func delete(contacts: [Contact]) {
        try! realm.write {
            realm.delete(contacts)
        }
    }
    
    func getContacts(wasDeleted: Bool = false) -> Results<Contact> {
        let predicate = NSPredicate(format: "wasDeleted = %@", argumentArray: [wasDeleted])
        let result = realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "givenName", ascending: true)
        return result
    }
    
/// This method is used to set the contact as deleted.
/// The contact is removed instantly from user's native "Contacts" App but it's stored in the database for later use (restoration).
    func setAsDeleted(contact: Contact) {
        try! realm.write {
            contact.setValue(true, forKey: "wasDeleted")
            contact.setValue(30, forKey: "daysToDeletion")
        }
    }
    
/// This method is used to unset the contact as deleted.
/// This is done after the contact is restored to user's native "Contacts" App
    func unsetAsDeleted(contact: Contact) {
        try! realm.write {
            contact.setValue(false, forKey: "wasDeleted")
            contact.setValue(0, forKey: "daysToDeletion")
        }
    }
    
    func getContact(_ identifier: String) -> Contact? {
        let databaseContacts = getContacts()
        return databaseContacts.first { $0.contactID == identifier }
    }
    
    func filterContacts(from searchTerm: String, wasDeleted: Bool) -> Results<Contact> {
        let predicate = NSPredicate(format: "givenName CONTAINS %@ AND wasDeleted = %@", argumentArray: [searchTerm, wasDeleted])
        return realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "givenName", ascending: true)
    }
    
    
//    TO-DO:
//    1 - Find a way of retrieving the deletion date and calculated permanent deletion date to update the database with the left days
//    2 - Find a place in code to make this update everytime the app is launched. TIP: Maybe in some AppDelegate method!
    func daysUntilPermanentDeletion() -> Int? {
        let calendar = Calendar.current
        let today = Date()
        let thirtyDaysAfter = calendar.date(byAdding: .day, value: 30, to: today)
        let daysUntilDeletion = calendar.dateComponents([.day], from: today, to: thirtyDaysAfter!).day
        
        return daysUntilDeletion
    }
}
