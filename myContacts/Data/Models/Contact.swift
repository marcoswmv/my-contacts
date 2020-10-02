//
//  Contact.swift
//  myContacts
//
//  Created by Marcos Vicente on 30.11.2019.
//  Copyright © 2019 Antares Software Group. All rights reserved.
//

import UIKit
import Contacts
import RealmSwift

class Contact: Object {
    
    @objc dynamic var contactID = ""
    @objc dynamic var givenName = ""
    @objc dynamic var familyName = ""
    @objc dynamic var thumbnailPhoto = Data()
    @objc dynamic var imageDataAvailable = false
    @objc dynamic var wasDeleted = false
    
    @objc dynamic var daysUntilDeletion = 0
    @objc dynamic var dayOfDeletion: Date? = nil
    @objc dynamic var scheduledDayOfDeletion: Date? = nil
    
    let phoneNumbersLabels = List<String>()
    let phoneNumbers = List<String>()
    
    let emailsLabels = List<String>()
    let emails = List<String>()

    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "contactID"
    }
    
    convenience init(contact: CNContact) {
        self.init()
        self.contactID = contact.identifier
        self.givenName = contact.givenName != "" ? contact.givenName : contact.organizationName
        self.familyName = contact.familyName
        self.imageDataAvailable = contact.imageDataAvailable
        self.thumbnailPhoto = (self.imageDataAvailable ? contact.imageData ?? Data() : Data())
        self.wasDeleted = false
        self.daysUntilDeletion = 0
        
        
        for contact in contact.phoneNumbers {
            self.phoneNumbersLabels.append(contact.label?.description ?? "Mobile")
            self.phoneNumbers.append(contact.value.stringValue)
        }
        
        for email in contact.emailAddresses {
            self.emailsLabels.append(email.label?.description ?? "Email")
            self.emails.append(email.value as String)
        }
    }
}
