//
//  Constants.swift
//  myContacts
//
//  Created by Marcos Vicente on 30.08.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import Foundation

struct Constants {
    
///    Singleton. This was created in order to avoid more than one object of type Constant being created.
///    The init is declared to prevent the struct's memberwise/parenthesys "()" from appearing
///    and is private to avoid the init to be called with dot notation
    static let shared = Constants()
    private init() { }
    
    let indexTitles = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
}
