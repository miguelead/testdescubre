//
//  NameChannelTableViewCell.swift
//  ChatChat
//
//  Created by Momentum Lab 1 on 11/10/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

protocol nameDelegate{
    func addChannelName(name: String)
}
class NameChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var nameField: UITextField!
    var delegate: nameDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension NameChannelTableViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else {
            return true
        }
        self.delegate?.addChannelName(name: text)
        return true
    }
}


