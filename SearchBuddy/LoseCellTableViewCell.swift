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
    
    class var expandedHeight: CGFloat {get { return 120} }
    class var defaultHeigth: CGFloat {get { return 80}}

    @IBOutlet weak var loseButton: UIButton!
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func hiddenItens(state: Bool){
        loseButton.hidden = state
    }
    
    func checkHeigth() {
        let state = (frame.size.height < LoseCellTableViewCell.expandedHeight) as Bool
        self.hiddenItens(state)
    }
    
    func watchFrameChanges() {
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
    }
    
    func ignoreFrameChanges() {
        if self.observationInfo != nil {
            removeObserver(self, forKeyPath: "frame")
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            self.checkHeigth()
        }
    }
    
    deinit{
        if self.observationInfo != nil {
            removeObserver(self, forKeyPath: "frame")
        }
    }
    
}
