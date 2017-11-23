//
//  SimpleMessageTableViewCell.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class SimpleMessageTableViewCell: UITableViewCell {


    @IBOutlet weak var textInfo: UILabel!
    @IBOutlet weak var titlePrincipal: UILabel!
    @IBOutlet weak var starIcon: UIImageView!
    
    var Message: MessageContent!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadInfo(_ message: MessageContent, actual: Bool){
        
    }
    
}
