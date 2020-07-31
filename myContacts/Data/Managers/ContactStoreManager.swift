//
//  ContactStoreManager.swift
//  myContacts
//
//  Created by Marcos Vicente on 31.07.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import Contacts
import RealmSwift

class ContactStoreManager {
    
    typealias ContactsFetchingCompletionHandler = (_ contact: Contact?, _ error: Error?) -> Void
    
    let store = CNContactStore()
    
    func fetchContacts(completionHandler: @escaping ContactsFetchingCompletionHandler) {
        
        DispatchQueue.global(qos: .background).async {
            
            self.store.requestAccess(for: .contacts) { (granted, error) in
                
                if let errorToCatch = error {
                    
//                    TO-DO: implement Alerts
                    print("Failed to request access: ", errorToCatch)
                } else if granted {
                    
                    print("Access granted!")
                    
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
