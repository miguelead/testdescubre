//
//  MarkbookSelectedTableViewCell.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/28/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit

class MarkbookSelectedTableViewCell: UITableViewCell {

    @IBOutlet weak var selector: UISwitch!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func checkEvent(_ sender: Any) {
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
