//
//  TableViewControllerAlerts.swift
//  myContacts
//
//  Created by Marcos Vicente on 01.12.2019.
//  Copyright © 2019 Antares Software Group. All rights reserved.
//

import UIKit

public class Alert {
    private static func showBasicAlert(on viewController: UIViewController,
                                       style: UIAlertController.Style,
                                       title: String?,
                                       message: String?,
                                       actions: [UIAlertAction] = [UIAlertAction(title: "Ok",
                                                                                style: .cancel,
                                                                                handler: nil)],
                                       completion: (() -> Void)? = nil) {
        
        let alert =  UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions { alert.addAction(action) }
        DispatchQueue.main.async { viewController.present(alert, animated: true, completion: completion) }
    }
    
    static func showErrorAlert(on viewController: UIViewController, message: String) {
        showBasicAlert(on: viewController,
                       style: .alert,
                       title: NSLocalizedString("An Error Occurred", comment: "Error alert title"),
                       message: message)
    }
    
    static func showNoContactSelectedAlert(on viewController: UIViewController, message: String) {
        showBasicAlert(on: viewController,
                       style: .alert,
                       title: NSLocalizedString("No Contact To Delete", comment: "No contact to delete alert title"),
                       message: message)
    }
    
    static func showActionSheetToAskForConfirmationToDelete(on viewController: UIViewController, _ completionHandler: @escaping ((Bool) -> Void)) {
        
        let title = NSLocalizedString("Are you sure?", comment: "Delete action sheet warning title")
        let message = NSLocalizedString("This deletion is permanent what means you won't be able to recover the contact(s) you are deleting now.", comment: "Delete action sheet explanatory message")
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Deletion button - Cancel"), style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: "Deletion button - Confirm"), style: .destructive, handler: { action in
            completionHandler(true)
        })
        
        showBasicAlert(on: viewController,
                       style: .actionSheet,
                       title: title,
                       message: message,
                       actions: [cancel, confirm])
    }
}
