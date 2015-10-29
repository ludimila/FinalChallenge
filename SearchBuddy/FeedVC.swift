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
        
//        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
<<<<<<< HEAD
        if Reachability.testConnection(){
            getData()
            print("Com conexao")
        }else{
            print("Sem conexao")
        }
        
=======
          getData()

>>>>>>> 04aec30f5835acd5e02aeb6f50e4a04d5336cbb9
        
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
        
//        let indexes = self.tableView.indexPathsForVisibleRows as Array!
//        
//        for var index in indexes {
//            let cellTeste = self.tableView.cellForRowAtIndexPath(index)
//            
////            cellTeste?.alpha = 0.1
//        }
        
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
            AnimalSingleton.sharedInstance().animalsArray = animalsArray!
            self.tableView.reloadData()
        }
        
    
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexes = self.tableView.indexPathsForVisibleRows as Array!
        
        
        var valores = Array<CGFloat>()
        var valoresIndex = Array<Int>()
        
        for index in indexes {
            
            let cellTeste = self.tableView.cellForRowAtIndexPath(index)
            let rectInTableView = self.tableView.rectForRowAtIndexPath(index)
            let rectInSuperview = self.tableView.convertRect(rectInTableView, toView: self.tableView.superview)
            
            var cellAmoutTela = (-30 + rectInSuperview.origin.y + (cellTeste?.frame.size.height)!)
            
            
            if cellAmoutTela > cellTeste?.frame.size.height{
                cellAmoutTela = (self.tableView.frame.size.height - (-30 + rectInSuperview.origin.y))
            }
            
            
            valoresIndex.append(index.row)
            valores.append(cellAmoutTela)
        }
        
        for var index in indexes {
            let cell = self.tableView.cellForRowAtIndexPath(index)
            
            if valoresIndex[(valores.indexOf(valores.maxElement()!))!] == index.row{
                cell?.alpha = 1
            }else{
                cell?.alpha = 0.5
            }
        }
    }
    
}
