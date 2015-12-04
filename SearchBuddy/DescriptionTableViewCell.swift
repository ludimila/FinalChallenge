//
//  DescriptionTableViewCell.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 10/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    

    @IBOutlet weak var descriptionAnimal: UITextField!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.descriptionAnimal.tintColor = UIColor.blackColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
