//
//  ProfileVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/20/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       /*
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.layer.cornerRadius = 60
        */
        
        
        self.backImage.image = UIImage(named: "arches-945495_1920.jpg")
        
        
        
    }

    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
       let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
       return cell
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
