//
//  CreateChannelTableViewController.swift
//  ChatChat
//
//  Created by Momentum Lab 1 on 11/10/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class CreateChannelTableViewController: UITableViewController {

    private var channelRefHandle: DatabaseHandle?
    private var usersRefHandle: DatabaseHandle?
    private var userslist: [Users] = []
    var nameChannel: String?
    var userSelect: [Users] = []
    
    private lazy var usersRef: DatabaseReference = Database.database().reference().child("Users")
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChannels()
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
        if let userRefHandle = usersRefHandle {
            usersRef.removeObserver(withHandle: userRefHandle)
        }
    }
    
    @IBAction func createChannel(_ sender: Any) {
        if let name = nameChannel, name.characters.count > 5{
                  let newChannelRef = channelRef.childByAutoId()
                  let channelItem = [
                    "name": name
                  ]
                  newChannelRef.setValue(channelItem)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func cancelOperation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        usersRefHandle = usersRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as? String, name.characters.count > 0 {
                self.userslist.append(Users(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : userslist.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectNameCell", for: indexPath) as! NameChannelTableViewCell
            cell.delegate = self
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! UserSelectChannelTableViewCell
        cell.nameCell.text = userslist[indexPath.row].name
        cell.userId = userslist[indexPath.row].id
        cell.delegate = self
        return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Agregar a un compañero"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120.0
        } else{
            return 50.0
        }
    }
}


extension CreateChannelTableViewController: nameDelegate{
    func addChannelName(name: String){
        self.nameChannel = name
    }
}

extension CreateChannelTableViewController: userSelectDelegate{
    func selectUser(id: String, status: Bool){
    
    }
}
