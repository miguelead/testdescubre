//
//  UIAlertView+Extensions.swift
//  testdescubre
//
//  Created by Momentum Lab 1 on 11/20/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    
    /**
     Create ViewController with options
     - returns: void
     - parameter title: Header of alert, default ERROR message
     - parameter message: message in alert , default empty string message
     - parameter nav: view controller when present alert , default nil
     - parameter subView: if exist subview add here , default nil
     - parameter style: type of alert , default alert style
     - parameter errorEvent: event when user touch cancel option, , default nil
     - parameter successEvent: event whe user touch ok option
     */
    class func presentViewController(title : String? = "Error", message : String? = "", nav: UINavigationController? = nil, style: UIAlertControllerStyle? = .alert, view: UIViewController? = nil, errorEvent: ((UIAlertAction) -> Void)? = nil, CancelLabel: String? = "Cancelar", OkLabel: String? = "Aceptar", successEvent: ((UIAlertAction)-> Void)? = {_ in }){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style!)
        
        if (successEvent != nil) {
            let okAction = UIAlertAction(title: OkLabel, style: .default, handler: successEvent)
            alert.addAction(okAction)
        }
        if (errorEvent != nil){
            let cancelAction = UIAlertAction(title: CancelLabel, style: .default, handler: errorEvent)
            alert.addAction(cancelAction)
        }
        
        if let currentViewController = nav {
            currentViewController.present(alert, animated: true)
        } else if let view = view {
            view.present(alert, animated: true)
        }
    }
    
    /**
     Present View Controller in actual view
     - returns: void
     - parameter viewController: View Controller
     - parameter into: destination viewController
     */
    class private func presentInViewController(viewController : UIViewController, into destination: UIViewController?){
        guard let destination = destination else{
            return
        }
        
        if let nav = destination as? UINavigationController, let lastViewController = nav.viewControllers.last{
            presentInViewController(viewController: viewController, into: lastViewController)
        }
        
        destination.present(viewController, animated: true) {}
    }
    
}
