//
//  AnimalTableViewCell.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 06/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var dataLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
