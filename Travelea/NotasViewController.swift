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

    
    var channelRef: DatabaseReference!
    fileprivate lazy var recomendRef: DatabaseQuery = self.channelRef.child("message").queryEqual(toValue: true, childKey: "favorite")
    fileprivate lazy var imageRef: DatabaseQuery = self.channelRef.child("message").queryOrdered(byChild: "imagenUrl")
    fileprivate var recomendRefHandle: DatabaseHandle?
    fileprivate var imageRefHandle: DatabaseHandle?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var mensaje: [MessageContent] = []
    fileprivate var resorce: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChannels()
    }
    
    deinit {
        if let recomendRefHandle = recomendRefHandle {
            recomendRef.removeObserver(withHandle: recomendRefHandle)
        }
        if let imageRefHandle = imageRefHandle {
            imageRef.removeObserver(withHandle: imageRefHandle)
        }
    }
    
    private func observeChannels() {
        recomendRefHandle = recomendRef.observe(.value, with: { (snapshots) in
            self.mensaje = []
            for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
                    let child_info = child.value as? Dictionary<String, AnyObject>
                    if let index = self.mensaje.index(where: { mensaje in return mensaje.uid == child.key}){
                        self.mensaje[index] = MessageContent(id: child.key, data: child_info)
                    } else {
                        self.mensaje.append(MessageContent(id: child.key, data: child_info))
                    }
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        )
        
        imageRefHandle = imageRef.observe(.value, with: { (snapshots) in
            self.resorce = []
            for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
                let child_info = child.value as? Dictionary<String, AnyObject>
                if let url_path = child_info?["imagenUrl"] as? String, let url = URL(string: url_path){
                    if let index = self.mensaje.index(where: { mensaje in return mensaje.uid == child.key}){
                        self.resorce[index] = url
                    } else {
                        self.resorce.append(url)
                    }
                }
            }
            self.tableView.reloadSections(IndexSet(integer: self.mensaje.isEmpty ? 0 : 1), with: .automatic)
        }
        )
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
