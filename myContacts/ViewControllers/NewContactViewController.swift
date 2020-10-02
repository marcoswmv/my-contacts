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
        choosePhotoSourceAlertController()
    }
    
    @IBAction func cancelOnTouchUpInside(_ sender:
    Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneOnTouchUpInside(_ sender: Any) {
//        TO-DO: Save new contact
        retrieveFormValues()
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
            <<< TextRow("firstName") {
                $0.placeholder = "First name"
            }
            <<< TextRow("familyName") {
                $0.placeholder = "Family name"
            }
            
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
                $0.tag = "phoneNumbers"
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
                    return PhoneRow() {
                        $0.placeholder = "Phone"
                    }
                }
            }
            
            
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
                $0.tag = "emails"
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
                    return EmailRow() {
                        $0.placeholder = "Email"
                        $0.add(rule: RuleEmail())
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
    
    fileprivate func retrieveFormValues() {
        self.view.endEditing(true)
        
        let firstNameRow: TextRow? = form.rowBy(tag: "firstName")
        let familyNameRow: TextRow? = form.rowBy(tag: "familyName")
        let phoneNumberSection: MultivaluedSection? = form.sectionBy(tag: "phoneNumbers") as? MultivaluedSection
        let emailsSection: MultivaluedSection? = form.sectionBy(tag: "emails") as? MultivaluedSection
        
        if let firstName = firstNameRow?.value,
           let familyName = familyNameRow?.value,
           let phoneNumberRows = phoneNumberSection?.allRows.dropLast(),
           let emailRows = emailsSection?.allRows.dropLast(),
           let newPhoto = photo.image?.pngData(){
            
            var phoneNumbers = [String]()
            var emails = [String]()
    
            phoneNumberRows.forEach { (row) in
                phoneNumbers.append(row.baseValue as! String)
            }
            emailRows.forEach { (row) in
                emails.append(row.baseValue as! String)
            }
            
            if !firstName.isEmpty || !familyName.isEmpty {
                NewContactManager.shared.createNewContact(firstName, familyName, phoneNumbers, emails, newPhoto)
            } else {
                Alert.showEmptyFieldsAlert(on: self, message: "Please, enter first or family name!")
            }
        }
        
    }
    
    @objc private func handleTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        choosePhotoSourceAlertController()
    }
}
