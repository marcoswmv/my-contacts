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
    
    func fetchContacts(completionHandler: @escaping ContactsFetchingCompletionHandler) {
        
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
}
