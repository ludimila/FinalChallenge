//
//  FeedTableViewCell.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 04/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    


    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
