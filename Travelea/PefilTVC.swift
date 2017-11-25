
//
//  PefilTVC.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/21/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Alamofire

import Firebase
import FBSDKLoginKit


class PefilTVC: UITableViewController {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var sitiosSs: UISwitch!
    @IBOutlet weak var ofertasSw: UISwitch!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var puntos: UILabel!
    @IBOutlet weak var checkIn: UILabel!
    @IBOutlet weak var nivel: UILabel!

    @IBOutlet weak var visitas: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImg.setRounded()
        loadData()
    }
    

    func loadData(){
        self.userName.text = CurrentUser.shared?._username ?? ""
        if let url = CurrentUser.shared?._userPhoto {
            self.avatarImg.kf.setImage(with: url)
        }
        self.checkIn.text = "0"
        self.puntos.text = "0"
        self.visitas.text = "0"
        
    }
    
    
    @IBAction func cerrarSesionbtn(_ sender: Any) {
        
    }
    
    
    @IBAction func recibirSitios(_ sender: Any) {
        if sitiosSs.isOn{
            actualizarAPI(opcion: 1, actualizar: true)
        }else{
            actualizarAPI(opcion: 1, actualizar: false)
        }
    }
    
    
    @IBAction func recibirOfertas(_ sender: Any) {
        if ofertasSw.isOn{
            actualizarAPI(opcion: 2, actualizar: true)
        }else{
            actualizarAPI(opcion: 2, actualizar: false)
        }
    }
    
    
    func actualizarAPI(opcion: Int, actualizar: Bool) {
      
        var body:[String: Any] = [:]
        body["user_id"] = 6
        if opcion == 1 {
            if actualizar == true{
                body["notification_flag_sites"] = 1
            }else{
                body["notification_flag_sites"] = 0
            }
        }
        if opcion == 2 {
            if actualizar == true {
                body["notification_flag_events"] = 1
            }else{
                body["notification_flag_events"] = 0
            }
        }
        let ruta = "http://192.168.0.101:8000/base/api/update/"
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.textLabel?.font = UIFont.init(name: "Avenir-Medium", size: 15)
    
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.init(name: "Avenir-Heavy", size: 15)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cerrar_session"{
            let firebaseAuth = Auth.auth()
            FBSDKLoginManager().logOut()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            AppDelegate.getAppDelegate().unregisterForPushNotifications()
        }
        
    }
    
    
}
