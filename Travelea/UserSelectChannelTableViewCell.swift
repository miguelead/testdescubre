//
//  UserSelectChannelTableViewCell.swift
//  ChatChat
//
//  Created by Momentum Lab 1 on 11/10/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

protocol userSelectDelegate{
    func selectUser(index: Int, status: Bool)
}

class UserSelectChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var checkUser: UISwitch!
    var userIndex:Int!
    var delegate: userSelectDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateStatusUser(_ sender: Any) {
        self.delegate?.selectUser(index: userIndex, status: checkUser.isOn)
    }
    
}
