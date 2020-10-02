//
//  NewContactManager.swift
//  myContacts
//
//  Created by Marcos Vicente on 25.09.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import Contacts

class NewContactManager {
    
    static let shared = NewContactManager()
    
    func createNewContact(_ firstName: String,
                          _ familyName: String,
                          _ phoneNumbers: [String],
                          _ emails: [String],
                          _ photo: Data) {
    
        // Create a new contact
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        newContact.familyName = familyName
        
        // Store the profile picture as data
        let image = UIImage(data:  photo)
        newContact.imageData = image?.jpegData(compressionQuality: 1.0)
        
        
        for phone in phoneNumbers {
            newContact.phoneNumbers.append(CNLabeledValue(
                                            label: "Mobile",
                                            value: CNPhoneNumber(stringValue: phone)))
        }
        
        for email in emails {
            newContact.phoneNumbers.append(CNLabeledValue(
                                            label: "E-mail",
                                            value: CNPhoneNumber(stringValue: email)))
        }
        
        ContactStoreManager.shared.addContact(Contact(contact: newContact))
    }
    
}
