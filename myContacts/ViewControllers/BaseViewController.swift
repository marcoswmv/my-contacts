//
//  BaseViewController.swift
//  ActiveCitizen
//
//  Created by Marcos Vicente on 02.12.2019.
//  Copyright © 2019 Antares Software. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var containerTableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    
//    var searchController = UISearchController()
    
    // MARK: - Variables
    
    /// Automatic authentication check. Logout if needed
    @IBInspectable var authenticationRequired: Bool = true
    
    /// Hide navigation bar
    @IBInspectable var hideNavigationBar: Bool  = false
    
    /// Hide tab bar
    @IBInspectable var hideTabBar: Bool  = false
    
    /// Enable navigation via keyboard toolbar. Movement based on UITextField tags. Don't forget set tags
    @IBInspectable var textFieldNavigation: Bool  = false
    
    /// Automaticly change scrollView insets and keyboardheightConstraint depends of keyboad state. Don't forget set IBOutlet contentScrollView or/and keyboardheightConstraint
    @IBInspectable var keyboardManagment: Bool = false
    {
        didSet {
            
            // Remove old observers
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil) 
        }
    }
    
    /// Is view is stil appearing. (Beyound WillAppear and DidAppear)
    private(set) var viewWillAppearInProgress = false
    
    /// Is screen is visible
    var isVisible: Bool  {
        get {
            return self.isViewLoaded && ((self.view?.window) != nil);
        }
    }
    
    /// Keyboard
    ///
    /// Keyboard height if keyboard is present
    private(set) var keyboardHeight: CGFloat = 0.0
    
    /// Automaticly change constraint with keyboard height
    @IBOutlet var keyboardHeightConstraint: NSLayoutConstraint?
    
    /// Automaticly change insets with keyboard height
    @IBOutlet var contentScrollView: UIScrollView?
    
    /// TextField
    ///
    /// Current textfield for textfield navigation
    var currentTextField: UITextField?
    
    /// Current textView
    var currentTextView: UITextView?
    
    
    // MARK: - Init, Appear, Override
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearInProgress = true;
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(self.hideNavigationBar, animated: true)
        self.tabBarController?.tabBar.isHidden = self.hideTabBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewWillAppearInProgress = false;
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    // MARK: - Instantiate

    /// Sotryboard name. Used in instantiate
    class func storyboardName() -> String? {
        // Override me
        return "Main"
    }

    /// Create instance of view controller with storyboard UI
    class func instantiate() -> BaseViewController {

        let storyboard = UIStoryboard(name: self.storyboardName() ?? "", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? BaseViewController
        assert(vc != nil, "Cannot find \(NSStringFromClass(self.self)) in \(self.storyboardName() ?? "").storyboard")
        return vc!
    }

    // MARK: - TextField navigation
    // Text fields navigation bar. Main implementstion: BaseViewController+TextFieldNavigation
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(self.textFieldNavigation){
            return self.textControlShouldBeginEditing(textControl: textField)
        }
        
        return true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(self.textFieldNavigation){
            return self.textControlShouldReturn(textField: textField)
        }
        textField.resignFirstResponder();
        return false;
    }

    
    // MARK: - Keyboard managment
    // Observe keyboard height
    
    @objc func keyboardWillShow(sender: NSNotification) {
        

        var height = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        keyboardHeight = height

        if tabBarController?.tabBar != nil && !(tabBarController?.tabBar.isHidden ?? false) {
            height -= tabBarController?.tabBar.frame.size.height ?? 0.0
        }

        let duration = TimeInterval((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0)

        if keyboardHeightConstraint != nil {
            keyboardHeightConstraint!.constant = height
        }

        UIView.animate(withDuration: duration, animations: {
            
            if self.contentScrollView != nil {
                var edgeInsets = self.contentScrollView!.contentInset //UIEdgeInsetsMake(0, 0, height + 20, 0);
                edgeInsets.bottom = height + 20
                self.contentScrollView!.contentInset = edgeInsets
                self.contentScrollView!.scrollIndicatorInsets = edgeInsets
            }

            if self.keyboardHeightConstraint != nil && !self.viewWillAppearInProgress {
                self.view.layoutSubviews()
            }
        })
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        
        let duration = TimeInterval((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0)
        keyboardHeight = 0
        
        if keyboardHeightConstraint != nil {
            keyboardHeightConstraint!.constant = 0;
        }
        
        UIView.animate(withDuration: duration, animations: {
            if self.contentScrollView != nil{
                var edgeInsets = self.contentScrollView!.contentInset //UIEdgeInsetsMake(0, 0, height + 20, 0);
                edgeInsets.bottom = 0;  //  possible problem for iPhone 6+ (10.0.1) because this device have non-zero .contentInset.bottom value before keyboard will shown
                self.contentScrollView!.contentInset = edgeInsets;
                self.contentScrollView!.scrollIndicatorInsets = edgeInsets;
            }
            
            if self.keyboardHeightConstraint != nil && !self.viewWillAppearInProgress {
                self.view.layoutSubviews()
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
