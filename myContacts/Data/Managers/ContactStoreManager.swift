//
//  ContactStoreManager.swift
//  myContacts
//
//  Created by Marcos Vicente on 31.07.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import Foundation
import Contacts
import RealmSwift

public struct ContactStoreManager {
    
///    Singleton. This was created in order to avoid more than one object of type DataBaseManager being created.
///    The init is declared to prevent the struct's memberwise/parenthesys "()" from appearing
///    and is private to avoid the init to be called with dot notation
    static let shared = ContactStoreManager()
    private init() { }
    
    typealias ContactsFetchingCompletionHandler = (_ contact: Contact?, _ error: Error?) -> Void
    
    private let store = CNContactStore()
    
    func requestContacts(completionHandler: @escaping ContactsFetchingCompletionHandler) {
        
        DispatchQueue.global(qos: .background).async {
            
            self.store.requestAccess(for: .contacts) { (granted, error) in
                
                if let errorToCatch = error {
                    
                    completionHandler(nil, errorToCatch)
                } else if granted {
                    
//                    print("Access granted!")
                    
                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,
                    CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey,
                    CNContactIdentifierKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey]
                    let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                    
                    do {
                        try self.store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                            let contact = Contact(contact: contact, wasDeleted: false)
                            completionHandler(contact, nil)
                        })
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    print("Access Denied")
                }
            }
        }
    }
    
/// This method is going to delete the contact from user's native "Contact" app.
    func deleteContact(with identifier: String) {
        
        if identifier.isEmpty {
            Alert.showNoContactSelectedAlert(on: UIApplication.topViewController()!, message: "Please select a contact to delete")
        } else {
            
            DataBaseManager.shared.setAsDeletedContact(with: identifier)

            let predicate = CNContact.predicateForContacts(withIdentifiers: [identifier])
            let keys = [CNContactIdentifierKey]
            
            do {
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
                guard contacts.count > 0 else { print("No contacts found"); return }
                guard let contact = contacts.first else { return }
                
                let request = CNSaveRequest()
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                
                request.delete(mutableContact)
                do {
                    try store.execute(request)
                    
                    print("The contact was successfully deleted!")
                } catch let err {
                    Alert.showErrorAlert(on: UIApplication.topViewController()!, message: err.localizedDescription)
                }
            } catch let error {
                Alert.showErrorAlert(on: UIApplication.topViewController()!, message: error.localizedDescription)
            }
        }
    }
}
