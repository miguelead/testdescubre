//
//  MarkBookViewController.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/28/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit
import Firebase

class MarkBookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listPlace:[(String,Bool,String)] = [] // nombre, status, id
    var selectActualPlace: Bool = false
    fileprivate lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    fileprivate lazy var channel_UserRef: DatabaseReference = Database.database().reference().child("channels_users")
    fileprivate var channelRefHandle: DatabaseHandle?
    fileprivate var channel_UserRefHandle: DatabaseHandle?
    var puntodeinteres : PuntoDeInteres!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        observeChannels()
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
        if let channel_UserRefHandle = channel_UserRefHandle {
            channel_UserRef.removeObserver(withHandle: channel_UserRefHandle)
        }
    }
    
    private func observeChannels() {
        channel_UserRefHandle = channel_UserRef.child(CurrentUser.shared?._id ?? "").observe(.value, with: { (snapshots) in
            self.listPlace = []
            for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
                self.channelRefHandle = self.channelRef.child(child.key).observe(.value, with: { (snapshot) -> Void in
                    let channelData = snapshot.value as? Dictionary<String, AnyObject>
                    if let name = channelData?["name"] as? String, name.characters.count > 0 {
                        if let index = self.listPlace.index(where: { channel in return channel.2 == child.key}){
                            self.listPlace[index] = (name, false , child.key)
                        } else {
                            self.listPlace.append((name, false , child.key))
                        }
                    }
                    self.tableView.reloadData()
                })
            }
        })
    }
}

extension MarkBookViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkbookSelectedTableViewCell", for: indexPath) as! MarkbookSelectedTableViewCell
        if indexPath.section == 0{
            cell.title.text = "Registrar en mi tablero"
            cell.selector.isOn = selectActualPlace
        } else {
            cell.title.text = listPlace[indexPath.row].0
            cell.selector.isOn = listPlace[indexPath.row].1
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Mi tablero" : "Mis grupos"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : listPlace.count
    }
}
