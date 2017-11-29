//
//  SimpleMessageTableViewCell.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class SimpleMessageTableViewCell: UITableViewCell {


    @IBOutlet weak var topCell: NSLayoutConstraint!
    @IBOutlet weak var topTitle: NSLayoutConstraint!
    @IBOutlet weak var textInfo: UILabel!
    @IBOutlet weak var titlePrincipal: UILabel!
    @IBOutlet weak var starIcon: UIImageView!
  
    var message: MessageContent!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadInfo(_ message: MessageContent, actual: Bool, inicio:Bool = true, final: Bool = true){
        self.message = message
        self.textInfo.text = message.mensaje
        self.titlePrincipal.text = actual ? "Yo": message.usuario
        starIcon.isHidden = !message.marker
        //titlePrincipal.isHidden = !inicio
        //topTitle.isActive = inicio
        //topCell.isActive = !inicio
    }
    
}
