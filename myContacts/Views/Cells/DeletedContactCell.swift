//
//  DeletedContactCell.swift
//  myContacts
//
//  Created by Marcos Vicente on 30.08.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class DeletedContactCell: UITableViewCell {

    @IBOutlet weak var givenName: UILabel!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var daysUntilPermanentDeletion: UILabel!
    
    var data: Contact? {
        didSet {
            givenName.text = data?.givenName
            familyName.text = data?.familyName
            daysUntilPermanentDeletion.text = "\(data!.daysUntilDeletion) days"
        }
    }
    
}
