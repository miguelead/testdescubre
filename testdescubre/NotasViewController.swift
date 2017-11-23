//
//  NotasViewController.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase

class NotasViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var channelRef: DatabaseReference!
    var mensaje: [MessageContent] = []
    var resorce: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NotasViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, mensaje.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollecionPhotoTableViewCell", for: indexPath) as! CollecionPhotoTableViewCell
            cell.selectionStyle = .none
            cell.imagesList = resorce
            return cell
        } else if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteMessageTableViewCell", for: indexPath) as! NoteMessageTableViewCell
            let mensajes = mensaje[indexPath.row]
            cell.selectionStyle = .none
            cell.loadInfo(mensajes)
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollecionPhotoTableViewCell", for: indexPath) as! CollecionPhotoTableViewCell
            cell.selectionStyle = .none
            cell.imagesList = resorce
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0 + (mensaje.isEmpty ? 0 : 1) + (resorce.isEmpty ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, mensaje.isEmpty {
            return resorce.count
        } else if section == 0{
            return mensaje.count
        } else{
            return resorce.count
        }
    }
    
}
