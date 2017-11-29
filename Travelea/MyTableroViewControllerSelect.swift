//
//  MyTableroViewController.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class MyTableroSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var userId: String!
    fileprivate lazy var boardRef: DatabaseReference = Database.database().reference().child("users")
    fileprivate lazy var placeRef: DatabaseReference = Database.database().reference().child("places_register")
    var listapuntodeinteres: [PuntoDeInteresTablero] = []
    fileprivate var channelRefHandle: DatabaseHandle?
    fileprivate var channel_placeRefHandle: DatabaseHandle?

    
    deinit {
        if let refHandle = channelRefHandle {
            boardRef.removeObserver(withHandle: refHandle)
        }
        if let channel_placeRefHandle = channel_placeRefHandle {
            placeRef.removeObserver(withHandle: channel_placeRefHandle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.addBackgroundImage(message: "")
        observeChannels()
    }
    
    private func observeChannels() {
        channelRefHandle = boardRef.child(CurrentUser.shared?._id ?? "").child("board").observe(.value, with: { (snapshots) in
            self.listapuntodeinteres = []
            let child_info = snapshots.value as? Dictionary<String, AnyObject>
            for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
                self.channel_placeRefHandle = self.placeRef.child(child.key).observe(.value, with: { (snapshot) -> Void in
                    let tableData = snapshot.value as? Dictionary<String, AnyObject>
                    if let tableData = tableData{
                        if let index = self.listapuntodeinteres.index(where: { punto in return punto._POIId == child.key}){
                            self.listapuntodeinteres[index] = PuntoDeInteresTablero(id: child.key, data: tableData, name: "", likes: child_info?["likes"] as? Int ?? 0, date: child_info?["date"] as? String ?? "")
                        } else {
                            self.listapuntodeinteres.append(PuntoDeInteresTablero(id: child.key, data: tableData, name: "", likes: child_info?["likes"] as? Int ?? 0, date: child_info?["date"] as? String ?? ""))
                        }
                    }
                    if self.listapuntodeinteres.isEmpty{
                        self.addBackgroundImage()
                    } else {
                        self.tableView.backgroundView = nil
                    }
                    self.tableView.reloadData()
                })
            }
        })
    }

    func addBackgroundImage(message: String = "No tienes ningun lugar guardado"){
        let image = #imageLiteral(resourceName: "emptystate-13").withRenderingMode(.alwaysTemplate)
        let topMessage = "Mis lugares"
        let bottomMessage = message
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableView.backgroundView = emptyBackgroundView
    }
}

extension MyTableroSelectViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresTableroCell
        let puntos = listapuntodeinteres[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(puntos)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listapuntodeinteres.count
    }
}
