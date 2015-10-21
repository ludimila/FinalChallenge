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
        getData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Table view data source
    
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
        
        let centerPoint = view.superview!.convertPoint(view.center, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(centerPoint)
        
        

    }
    
        
}
