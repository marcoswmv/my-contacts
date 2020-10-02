//
//  NewContactViewController.swift
//  myContacts
//
//  Created by Marcos Vicente on 05.09.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import Eureka

class NewContactViewController: FormViewController {
    
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
        setupUI()
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
    
    fileprivate func layoutNewContactForm() {
        form +++ Section()
            <<< TextRow() { row in
                row.placeholder = "First name"
            }
            <<< TextRow() { row in
                row.placeholder = "Family name"
            }
            
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
                $0.addButtonProvider = { section in
                    return ButtonRow() {
                        $0.title = "Add"
                    }
                    .cellUpdate { (cell, row) in
                        cell.textLabel?.textColor = .label
                        cell.textLabel?.textAlignment = .left
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return NameRow() {
                        $0.placeholder = "Phone"
                    }
                }
            }
            
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
                $0.addButtonProvider = { section in
                    return ButtonRow() {
                        $0.title = "Add"
                    }
                    .cellUpdate { (cell, row) in
                        cell.textLabel?.textColor = .label
                        cell.textLabel?.textAlignment = .left
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return NameRow() {
                        $0.placeholder = "Email"
                    }
                }
            }
    }
    
    fileprivate func setupCustomImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGestureRecognizer:)))
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(tapGestureRecognizer)
        photo.layer.cornerRadius = photo.bounds.height / 2
        photo.clipsToBounds = true
    }
    
    fileprivate func setupUI() {
        setupCustomImageView()
        layoutNewContactForm()
    }
    
    @objc private func handleTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Picking photo")
    }
}
