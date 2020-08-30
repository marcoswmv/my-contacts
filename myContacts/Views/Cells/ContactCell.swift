//
//  ContactCell.swift
//  myContacts
//
//  Created by Marcos Vicente on 06.08.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var givenName: UILabel!
    @IBOutlet weak var familyName: UILabel!
    
    var data: Contact? {
        didSet {
            givenName.text = data?.givenName
            familyName.text = data?.familyName != "" ? data?.familyName : ""
        }
    }
}
