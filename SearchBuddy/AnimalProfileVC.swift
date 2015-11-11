//
//  AnimalProfileVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 09/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    //scroll
    var pageControl: UIPageControl!
    var scrollView: UIScrollView!
    var animalPicture: UIImageView!
    
    //tableView
    @IBOutlet weak var tableView: UITableView!
    
    //algo
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalBreed: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

          configuraPageControl()
          loadScroll()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0{
        
           let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! AnimalLocationTableViewCell
            return cell
            
        }
        
       else if indexPath.row == 1{
            
         let cell = tableView.dequeueReusableCellWithIdentifier("ownerCell", forIndexPath: indexPath) as! AnimalOwnerTableViewCell
            return cell
            
        
        }
        
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("aboutCell", forIndexPath: indexPath) as! AnimalAboutTableViewCell
            return cell

        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as! DescriptionTableViewCell
            return cell

        
        }
        
    }
    
    
    
    
    //scroll
    
    func loadScroll(){
        
        
        self.scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        self.view.addSubview(self.scrollView)
        
        for var i = 1; i < 3; i++ {
            
            self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width*CGFloat(i), self.view.frame.height/2)
          
            self.animalPicture = UIImageView(frame: self.scrollView.frame)
            self.animalPicture.contentMode = .ScaleAspectFit
            self.animalPicture.image = UIImage(named:"animal"+String(i))
            
            self.scrollView.addSubview(self.animalPicture)
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 4 , self.scrollView.frame.size.height)
    }
    
    
    func configuraPageControl() {
        
        self.pageControl = UIPageControl(frame: CGRectMake(0, 0, 100, 50))
        self.pageControl.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.orangeColor()
        self.pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        self.view.addSubview(self.pageControl)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pagina = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width/2)/self.scrollView.frame.width)+1
        self.pageControl.currentPage = Int(pagina)
        
        print("Pagina: \(pagina)")
    }

    
}
