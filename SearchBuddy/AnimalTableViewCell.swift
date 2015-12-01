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
    var segmentType = UISegmentedControl()
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
    
    
    func selectStatus(){
        
        let itemSegment = ["Gato", "Cachorro", "Outro"]
        self.segmentType = UISegmentedControl(items: itemSegment)
        
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        self.segmentType.frame = CGRectMake(frame.midX, 10 ,frame.width/2, frame.height/20)
        
        // Style the Segmented Control
        self.segmentType.layer.cornerRadius = 5.0  // Don't let background bleed
        self.segmentType.backgroundColor = UIColor.orangeColor()
        self.segmentType.tintColor = UIColor.whiteColor()
    }
}
