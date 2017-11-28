//
//  MarkBookViewController.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/28/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit

class MarkBookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listPlace:[(String,Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension MarkBookViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkbookSelectedTableViewCell", for: indexPath) as! MarkbookSelectedTableViewCell
        cell.title.text = listPlace[indexPath.row].0
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlace.count
    }
}
