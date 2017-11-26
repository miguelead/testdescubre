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
    func addImageChannel()
}
class NameChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var channelsImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    var delegate: nameDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameField.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        channelsImage.isUserInteractionEnabled = true
        channelsImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if let text = self.nameField.text, !text.isEmpty{
            self.delegate?.addChannelName(name: text)
        }
        self.delegate?.addImageChannel()
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        self.delegate?.addChannelName(name: text)

    }
}





