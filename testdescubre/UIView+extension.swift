//
//  UIView+extension.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/14/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    /**
     Change hex code to UIColor
     - returns: UIColor
     - parameter hex: hex string code
     */
    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}


extension UIImageView {
    
    func changeImageColor(color: UIColor?) -> UIImage?{
        guard let color = color, image != nil else{ return self.image }
        image = image!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return image!
    }
    
}

