//
//  ProfileVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/20/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var ocupacao: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.bounces = false
       
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.layer.cornerRadius = 60
        
        self.backImage.image = UIImage(named: "arches-945495_1920.jpg")
        
        self.background.backgroundColor = UIColor(red:0.49, green:0.91, blue:1.00, alpha:0.8)
        self.nome.text = "Ludimila Castro"
        self.ocupacao.text = "Personal Trainer"
        
        self.tableView.separatorColor = UIColor.orangeColor()
        
        
        //self.collectionView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Perfil"
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
        
        
        if (  indexPath.row == 0 ){
            
            cell.img.image = UIImage(named: "phone")
            cell.label.text = "(61) 9999-6999"
            
        }
        
        if ( indexPath.row == 1 ){
            
            cell.img.image = UIImage(named: "pin")
            cell.label.text = "Brasilia"
            
        }
        
        if ( indexPath.row == 2 ){
            
            cell.backgroundColor = UIColor.orangeColor()
            cell.label.text = "Animais:"
            
        }
        
        if ( indexPath.row > 2 ) {
            
            cell.img.layer.borderWidth = 1.0
            cell.img.layer.masksToBounds = true
            cell.img.layer.borderColor = UIColor.orangeColor().CGColor
            cell.img.layer.cornerRadius = 25
            cell.img.image = UIImage(named: "sadPuppy")
            cell.label.text = "Godinho"
            
        }
        
        return cell
    }
    
    /*
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! Cell
        
        cell.picture.image = UIImage(named: "sadPuppy")
        cell.picture.layer.borderWidth = 2.0
        cell.picture.layer.masksToBounds = true
        cell.picture.layer.borderColor = UIColor.whiteColor().CGColor
        cell.picture.layer.cornerRadius = 25
        

        return cell
        
    }
    
    override func viewWillLayoutSubviews() {
        
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        print(" Identificador -> \(segue.identifier)")
        
        if (segue.identifier == "addAnimal") {
            var uVC = segue.destinationViewController as! UserVC
            uVC = UserVC()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
