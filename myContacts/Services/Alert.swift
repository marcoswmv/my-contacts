//
//  TableViewControllerAlerts.swift
//  myContacts
//
//  Created by Marcos Vicente on 01.12.2019.
//  Copyright © 2019 Antares Software Group. All rights reserved.
//

import UIKit

public class Alert {
    private static func showBasicAlert(on viewController: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert button - OK"),
                                      style: .default,
                                      handler: nil))
        DispatchQueue.main.async { viewController.present(alert, animated: true, completion: nil) }
    }
    
    static func showFetchingErrorAlert(on viewController: UIViewController, message: String) {
        showBasicAlert(on: viewController,
                       with: NSLocalizedString("fetching.404", comment: "Fetching Error Title"),
                       message: message)
    }
    
    static func showActionSheetAlert(on viewController: UIViewController,
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
}
