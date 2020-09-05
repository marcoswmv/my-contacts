//
//  NewContactViewController.swift
//  myContacts
//
//  Created by Marcos Vicente on 05.09.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class NewContactViewController: BaseViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func pickImageOnTouchUpInside(_ sender: Any) {
    }
    
    @IBAction func cancelOnTouchUpInside(_ sender:
    Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneOnTouchUpInside(_ sender: Any) {
//        TO-DO: Save new contact
        dismiss(animated: true)
    }
    //    MARK: - PROPERTIES
    
//    MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed {
            print("I'm being dismissed!")
        }
    }
    
//    MARK: - METHODS
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "New Contact"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

}
