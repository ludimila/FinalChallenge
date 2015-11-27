//
//  LoseCellTableViewCell.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 11/27/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class LoseCellTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
