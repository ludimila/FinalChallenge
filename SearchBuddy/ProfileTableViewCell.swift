//
//  ProfileTableViewCell.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 06/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var findedButton: UIButton!
    
    override func prepareForReuse() {
        self.img.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
