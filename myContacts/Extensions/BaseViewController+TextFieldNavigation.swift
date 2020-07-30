//
//  BaseViewController+TextFieldNavigation.swift
//  ActiveCitizen
//
//  Created by Dmitry Byankin on 02.12.2019.
//  Copyright © 2019 Antares Software. All rights reserved.
//

import UIKit

extension BaseViewController {
    
    func textControlShouldBeginEditing(textControl: UITextField) -> Bool {
        
        self.currentTextField = textControl;

        let index = textControl.tag;
        let nextTextField = self.getTextControlWithTag(tag: index+1)
        let prevTextField = self.getTextControlWithTag(tag: index-1)
            
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30)]
            
        let previousBarButton = UIBarButtonItem.init(title: " ◄ ", style: .plain, target: self, action: #selector(previousTextFieldAction))
        previousBarButton.isEnabled = prevTextField?.isEnabled ?? false;
        previousBarButton.setTitleTextAttributes(attributes, for: .normal)
        previousBarButton.setTitleTextAttributes(attributes, for: .highlighted)
        previousBarButton.setTitleTextAttributes(attributes, for: .disabled)
        previousBarButton.tintColor = .blue
        
        let nextBarButton = UIBarButtonItem.init(title: " ► ", style: .plain, target: self, action: #selector(nextTextFieldAction))
        nextBarButton.isEnabled = nextTextField?.isEnabled ?? false;
        nextBarButton.setTitleTextAttributes(attributes, for: .normal)
        nextBarButton.setTitleTextAttributes(attributes, for: .highlighted)
        nextBarButton.setTitleTextAttributes(attributes, for: .disabled)
        nextBarButton.tintColor = .blue
        
        let doneBarButton = UIBarButtonItem.init(title: "Готово", style: .done, target: self, action: #selector(resignKeyboard))
        doneBarButton.tintColor = .blue
            
        let keyboardToolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40.0))
        keyboardToolBar.barStyle = .default;
            
        var barItems : [UIBarButtonItem] = []
        
        if((nextTextField != nil) || (prevTextField != nil)){
            barItems.append(previousBarButton)
            barItems.append(nextBarButton)
        }
        
        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(doneBarButton)
        keyboardToolBar.setItems(barItems, animated: false)
        self.currentTextField?.inputAccessoryView = keyboardToolBar

        return true;
    }
    

    func textControlShouldReturn(textField: UITextField) -> Bool {
        
        if((textField as UITextField).returnKeyType == .next){
            self.nextTextFieldAction()
            return false;
        }
        
        if((textField as UITextField).returnKeyType == .done){
            resignKeyboard()
            return false;
        }
        
        return false
    }
        
    @objc private func nextTextFieldAction() {
        
        if(self.currentTextField != nil){
            
            let index = self.currentTextField!.tag
            let prevTextField = self.getTextControlWithTag(tag: index+1)
            prevTextField?.becomeFirstResponder()
        }
    }
    
    @objc private func previousTextFieldAction() {
        
        if(self.currentTextField != nil){
            
            let index = self.currentTextField!.tag
            let prevTextField = self.getTextControlWithTag(tag: index-1)
            prevTextField?.becomeFirstResponder()
        }
    }

    @objc private func resignKeyboard() {
        
        if(self.currentTextField != nil){
            self.currentTextField?.resignFirstResponder()
            self.currentTextField = nil;
        }
    }

    private func getTextControlWithTag(tag: Int) -> UIControl? {
        
        let view = self.view.viewWithTag(tag)
        if(view != nil && view!.responds(to: #selector(becomeFirstResponder))){
            return view as? UIControl;
        }
        return nil;
    }  
}
