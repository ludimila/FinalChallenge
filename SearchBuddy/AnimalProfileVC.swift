//
//  AnimalProfileVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 09/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalBreed: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = AnimalProfileTableViewCell()
        let marray:NSArray = NSArray()
        let obj = marray[indexPath.row]
        
        if obj  == 0{
            
            cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! AnimalProfileTableViewCell
        }
        
        if indexPath.row == 1{
        
           cell = tableView.dequeueReusableCellWithIdentifier("ownerCell", forIndexPath: indexPath) as! AnimalProfileTableViewCell
            
        }
        
        if indexPath.row == 2{
            
         cell = tableView.dequeueReusableCellWithIdentifier("aboutCell", forIndexPath: indexPath) as! AnimalProfileTableViewCell
            
        
        }
        
        if indexPath.row == 3{
            cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as! AnimalProfileTableViewCell

        }
        
        
        return cell
    }
}
