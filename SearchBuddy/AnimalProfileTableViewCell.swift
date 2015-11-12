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
        
      //  configuraPageControl()
      //  loadScroll()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func loadScroll(){
    

        self.scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        self.addSubview(self.scrollView)

        for var i = 1; i < 3; i++ {
            
            var frame = CGRect()
            frame.origin.x = (self.scrollView.frame.size.width * CGFloat(i))+16
            frame.origin.y = self.scrollView.frame.size.height/2
            frame.size = CGSizeMake(self.scrollView.frame.size.width-32, self.scrollView.frame.size.height/2.0)
            
            self.animalPicture = UIImageView(frame: frame)
            self.animalPicture.contentMode = .ScaleAspectFit
            self.animalPicture.image = UIImage(named:"animal"+String(i))
            
            self.scrollView.addSubview(self.animalPicture)
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 4 , self.scrollView.frame.size.height)
    }
    
    
    func configuraPageControl() {
        
        self.pageControl = UIPageControl(frame: CGRectMake(0, 0, 100, 50))
        self.pageControl.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height-100)//50
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.orangeColor()
        self.pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.7)
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 204/255, green: 0/255, blue: 68/255, alpha: 1)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pagina = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width/2)/self.scrollView.frame.width)+1
        self.pageControl.currentPage = Int(pagina)
    }

}
