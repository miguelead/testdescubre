//
//  CheckInVC.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class CheckInVC: UIViewController {

    @IBAction func CancelarBtn(_ sender: Any) {
    
        self.tabBarController?.selectedIndex = 0
        
    }
    
    
    
    @IBAction func GuardarBtn(_ sender: Any) {

        // Accion de enviar 
        
        self.tabBarController?.selectedIndex = 0
    
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
