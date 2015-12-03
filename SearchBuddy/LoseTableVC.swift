//
//  LoseTableVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 11/27/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class LoseTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCellIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.separatorColor = UIColor.orangeColor()

        AnimalDAO.getLostAnimalsFromUser(User.currentUser()!) { () -> Void in
            self.tableView.reloadData()
            if AnimalDAO.sharedInstance().allLostAnimalsUser.count > 0{
                self.tableView.hidden = false
                //self.tableviewIsEmptylb.hidden = true
            }else{
                self.tableView.hidden = true
                //self.tableviewIsEmptylb.hidden = false
            }
        }
        self.addEditButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AnimalDAO.sharedInstance().allLostAnimalsUser.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let animal = AnimalDAO.sharedInstance().allLostAnimalsUser[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LoseCellTableViewCell
        
        animal.animalPicture?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil{
                cell.img.image = UIImage(data: data!)
                Utilities.round(cell.img, tamanhoBorda: 1)
                cell.img.layer.borderColor = UIColor.orangeColor().CGColor
            }
        })
        
        cell.label.text = animal.animalName
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedCellIndexPath = self.selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                self.selectedCellIndexPath = nil
            } else {
                self.selectedCellIndexPath = indexPath
            }
        } else {
            selectedCellIndexPath = indexPath
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! LoseCellTableViewCell).watchFrameChanges()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! LoseCellTableViewCell).ignoreFrameChanges()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let selectedCellIndexPath = self.selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                return LoseCellTableViewCell.expandedHeight
            }
        }
        return LoseCellTableViewCell.defaultHeigth
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lostLocation"{
            
            let vc = segue.destinationViewController as! BuscaLocalVC
            let animal = AnimalDAO.sharedInstance().allLostAnimalsUser[(selectedCellIndexPath?.row)!]
            
            vc.animal = animal
        }
    }
    
    func addEditButton(){
        let rightBarButton = UIBarButtonItem(title: "Cancelar", style: .Plain, target: self, action: "cancelAction")
        
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func cancelAction(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
