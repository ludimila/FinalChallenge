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
    
    var switchVaccinated = UISwitch()
    var segmentStatus = UISegmentedControl()
    var items = Array<StatusAnimal>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectVaccinated()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func selectVaccinated(){
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        self.switchVaccinated.frame = CGRectMake(frame.midX+(frame.midX/2), 10 ,frame.width/2, frame.height/20)
    }
    
}
