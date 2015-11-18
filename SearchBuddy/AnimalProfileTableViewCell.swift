//
//  AnimalProfileTableViewCell.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 10/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalProfileTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
  //var scrollView: UIScrollView!
 // var animalPicture: UIImageView!
//  var pageControl: UIPageControl!
 
    

    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
