//
//  UIApplicationGetTopViewController.swift
//  myContacts
//
//  Created by Marcos Vicente on 01.12.2019.
//  Copyright © 2019 Antares Software Group. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {

       if let nav = base as? UINavigationController {
           return topViewController(base: nav.visibleViewController)

       } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
           return topViewController(base: selected)

       } else if let presented = base?.presentedViewController {
           return topViewController(base: presented)
       }
       return base
    }
}
