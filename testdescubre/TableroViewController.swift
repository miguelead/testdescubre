//
//  TableroViewController.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase

class TableroViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var channelRef: DatabaseReference!
    fileprivate lazy var boardRef: DatabaseReference = self.channelRef.child("boards")
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
    
    @IBAction func addLogic(_ sender: Any) {
    }
    
    private func observeChannels() {
        channelRefHandle = boardRef.observe(.value, with: { (snapshots) in
            self.listapuntodeinteres = []
            for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
                self.channel_placeRefHandle = self.placeRef.child(child.key).observe(.value, with: { (snapshot) -> Void in
                    let channelData = snapshot.value as? Dictionary<String, AnyObject>
                    if let name = channelData?["name"] as? String, name.characters.count > 0 {
                       
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

    func addBackgroundImage(message: String = "No tienes lugares disponibles en el tablero"){
        let image = #imageLiteral(resourceName: "emptystate-13").withRenderingMode(.alwaysTemplate)
        let topMessage = "Tablero de lugares"
        let bottomMessage = message
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableView.backgroundView = emptyBackgroundView
    }
}

extension TableroViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntodeinteresCell", for: indexPath) as! puntodeinteresTableroCell
        let puntos = listapuntodeinteres[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(puntos, lat: 0.0,lon: 0.0)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listapuntodeinteres.count
    }
    
}
