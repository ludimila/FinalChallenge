//
//  LoseCellTableViewCell.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 11/27/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

class LoseCellTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func callButton(sender: AnyObject) {
    
        let pushQuery = PFInstallation.query()
        pushQuery?.whereKey("deviceType", equalTo: "ios")
        
        PFPush.sendPushMessageToQueryInBackground(pushQuery!, withMessage: "\(self.label.text!) está perdido." )
    
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
