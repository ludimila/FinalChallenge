//
//  FeedVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 04/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var teste = Int()
    
    @IBOutlet weak var tableView: UITableView!
    var animalsArray = Array<Animal>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        getData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        let currentAnimal : Animal = self.animalsArray[indexPath.row]
        
        cell.animalName.text = currentAnimal.animalName
        let status = currentAnimal.animalStatus!
        let description = currentAnimal.animalDescription!
        
        cell.animalStatus.text = String(status["situation"])
        cell.animalDescription.text = description
        
        return cell
    }
    
    func getData(){
        
        AnimalDAO.getLostAnimals { (animalsArray, error) -> Void in
            self.animalsArray = animalsArray!
            
            self.tableView.reloadData()
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let cellIndex = tableView.indexPathForRowAtPoint(self.tableView.center){
            print(cellIndex.row)
            let cell = tableView.cellForRowAtIndexPath(cellIndex) as! FeedTableViewCell
            print(cell.animalName.text)

            cell.hiddenBlackView()

        }        
        
        
//        var centerPoint = cell.frame.origin
//        centerPoint = cell.convertPoint(centerPoint, fromCoordinateSpace: self.tableView)
//        let halfScreen = self.view.center.y
//        
//        if ((centerPoint.y * -1) == halfScreen){
//            
//            
//        }
//        print(halfScreen)
//        print(centerPoint)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.hiddenBlackView()

    }
    
}
