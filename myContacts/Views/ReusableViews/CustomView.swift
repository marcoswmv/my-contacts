//
//  CustomView.swift
//  myContacts
//
//  Created by Marcos Vicente on 25.09.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class CustomView: UIView {

    @IBInspectable var firstColor: UIColor?
    @IBInspectable var secondColor: UIColor?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        if let firstColor = firstColor,
           let secondColor = secondColor {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }

}
