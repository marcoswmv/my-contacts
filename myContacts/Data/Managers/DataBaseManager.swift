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
    private var token: NotificationToken!
    var dataChanged: ((_ result: Results<Contact>?) -> Void)?
    private let calendar = Calendar.current
    
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
    
/// This method is used to make the request for the contacts to the user's iPhone.
/// Then it populates the database using the update(:) method
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
    
/// This method is used to populate/update the database with data received from Contacts App service. That is Create/Update contact objects in DB.
/// The redeclaration of the realm is mandatory in this method, because it is going to accessed from another thread.
    func update(with contact: Contact) {
        let realm = try! Realm()
        try! realm.write({
            realm.create(Contact.self, value: contact, update: .modified)
        })
    }
        
/// This method Reads all the data from database.
    func getContacts(wasDeleted: Bool = false) -> Results<Contact> {
        let predicate = NSPredicate(format: "wasDeleted = %@", argumentArray: [wasDeleted])
        let result = realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "givenName", ascending: true)
        return result
    }
    
/// This method is used to permanently Delete the contact from the database. And the contact is not restorable anymore.
    func delete(contacts: [Contact]) {
        try! realm.write {
            realm.delete(contacts)
        }
    }
    
/// This method is used to set the contact as deleted.
/// The contact is removed instantly from user's native "Contacts" App but it's stored in the database for later use (restoration).
    func setAsDeleted(contact: Contact) {
        let dayOfDeletion = Date()
       
        guard let scheduledDayOfDeletion = calendar.date(byAdding: .day, value: 30, to: dayOfDeletion),
            let daysLeftForDeletion = calendar.dateComponents([.day],
                                                              from: dayOfDeletion,
                                                              to: scheduledDayOfDeletion).day else { return }
        try! realm.write {
            contact.setValue(true, forKey: "wasDeleted")
            contact.setValue(dayOfDeletion, forKey: "dayOfDeletion")
            contact.setValue(scheduledDayOfDeletion, forKey: "scheduledDayOfDeletion")
            contact.setValue(daysLeftForDeletion, forKey: "daysUntilDeletion")
        }
    }
    
/// This method is used to unset the contact as deleted.
/// This is done after the contact is recovered to user's native "Contacts" App
    func unsetAsDeleted(contact: Contact) {
        try! realm.write {
            contact.setValue(false, forKey: "wasDeleted")
            contact.setValue(nil, forKey: "dayOfDeletion")
            contact.setValue(nil, forKey: "scheduledDayOfDeletion")
            contact.setValue(0, forKey: "daysUntilDeletion")
        }
    }
    
/// This method is used during search to filter contacts on the table
    func filterContacts(from searchTerm: String, wasDeleted: Bool) -> Results<Contact> {
        let predicate = NSPredicate(format: "givenName CONTAINS %@ AND wasDeleted = %@", argumentArray: [searchTerm, wasDeleted])
        return realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "givenName", ascending: true)
    }
    
/// This method is going to update the days until deletion for a contact or delete it in case there are no days left
    func updateDaysUntilDeletion(for contact: Contact) {
        let currentDay = Date()
        
//        TO-DO: Problem with daysUntilDeletion. It's returning less days then it should. For ex: on first day of deletion it should show 30 but it's showing 29.
        guard let scheduledDayOfDeletion = contact.scheduledDayOfDeletion,
            let daysUntilDeletion = calendar.dateComponents([.day],
                                                            from: currentDay,
                                                              to: scheduledDayOfDeletion).day else { return }
        
        if daysUntilDeletion > 0 {
            try! realm.write({
                realm.create(Contact.self, value: ["contactID": contact.contactID,
                                                   "daysUntilDeletion": daysUntilDeletion], update: .modified)
            })
        } else {
            try! realm.write {
                realm.delete(contact)
            }
        }
    }
}
