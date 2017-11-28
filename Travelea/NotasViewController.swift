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
    fileprivate lazy var recomendRef: DatabaseReference = self.channelRef.child("favorites")
    fileprivate lazy var imageRef: DatabaseReference = self.channelRef.child("images")
    fileprivate lazy var messageRef: DatabaseReference = self.channelRef.child("messages")
    fileprivate var recomendRefHandle: DatabaseHandle?
    fileprivate var imageRefHandle: DatabaseHandle?
    fileprivate var messageRefHandle: DatabaseHandle?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var mensaje: [MessageContent] = []
    fileprivate var resorce: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        observeChannels()
    }
    
    deinit {
        if let recomendRefHandle = recomendRefHandle {
            recomendRef.removeObserver(withHandle: recomendRefHandle)
        }
        if let imageRefHandle = imageRefHandle {
            imageRef.removeObserver(withHandle: imageRefHandle)
        }
        if let messageRefHandle = messageRefHandle {
            messageRef.removeObserver(withHandle: messageRefHandle)
        }
    }
    
    private func observeChannels() {
        recomendRefHandle = recomendRef.observe(.value, with: {(snapshots) in
            self.mensaje = []
            for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
                    self.messageRefHandle = self.messageRef.child(child.key).observe(.value, with: { (snapshots) in
                    let child_info = snapshots.value as? Dictionary<String, AnyObject>
                    if let index = self.mensaje.index(where: { mensaje in return mensaje.uid == child.key}){
                        self.mensaje[index] = MessageContent(id: child.key, data: child_info)
                    } else {
                        self.mensaje.append(MessageContent(id: child.key, data: child_info))
                    }
                    self.tableView.reloadData()
                })
            }
        })
        
        imageRefHandle = imageRef.observe(.value, with: { (snapshots) in
            self.resorce = []
            for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
                let urlImage = child.value as? String
                if let url_path = urlImage, let url = URL(string: url_path){
                    if let index = self.mensaje.index(where: { mensaje in return mensaje.uid == child.key}){
                        self.resorce[index] = url
                    } else {
                        self.resorce.append(url)
                    }
                }
            }
            self.tableView.reloadData()
            
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
            return 1
        } else if section == 0{
            return mensaje.count
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0, mensaje.isEmpty{
            return "Fotos enviadas al chat"
        } else if section == 0{
            return "Mensajes destacados"
        } else {
            return "Fotos enviadas al chat"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, mensaje.isEmpty{
            return getHeight(itemsPerRow: 3.0, hardCodedPadding: 0.0)
        } else if indexPath.section == 0{
            return UITableViewAutomaticDimension
        } else {
            return getHeight(itemsPerRow: 3.0, hardCodedPadding: 0.0)
        }
    }
    
    func getHeight(itemsPerRow: CGFloat = 3.0, hardCodedPadding: CGFloat = 0.0) -> CGFloat{
        let itemHeight = tableView.bounds.size.width - (2.0) - ((itemsPerRow-1) * 1.0)
        let totalRow = ceil(Double(CGFloat(resorce.count) / itemsPerRow))
        let totalTopBottomOffset: CGFloat = 1.0
        let totalSpacing = CGFloat(totalRow - 1) * hardCodedPadding
        let totalHeight  = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffset + totalSpacing)
        return totalHeight
    }
}
