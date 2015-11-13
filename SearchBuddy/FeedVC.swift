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
    
//    RefreshControl
    var refreshTableView : UIRefreshControl? = UIRefreshControl()
    var customView: UIView!
    var labelsArray: Array<UILabel> = []
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Feed"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.allowsSelection = false
        self.refreshTableView!.backgroundColor = UIColor.redColor()
        self.refreshTableView!.addTarget(self, action: "reloadTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshTableView!)
        
        loadCustomRefreshContent()
        
        
        if Reachability.testConnection(){
            getData()
            print("Com conexao")
        }else{
            print("Sem conexao")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadTableView() {
        print("RELOAD")
        
        self.refreshTableView!.endRefreshing()
        self.refreshTableView!.removeFromSuperview()
    }
    
    func loadCustomRefreshContent() {
        let refreshContets = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        self.customView = refreshContets[0] as! UIView
        self.customView.frame = self.refreshTableView!.bounds
        
        for var i=0; i<customView.subviews.count; i++ {
            labelsArray.append(self.customView.viewWithTag(i + 1) as! UILabel)
        }
        
        self.refreshTableView!.addSubview(self.customView)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        

        if let currentAnimal : Animal = self.animalsArray[indexPath.row]{
            currentAnimal.animalPicture?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil{
                    cell.fotoAnimal.image = UIImage(data: data!)
                }
            })
            
            
            
            
            cell.fotoPerfilDono.image = UIImage(named: "dog")
            
            cell.fotoPerfilDono.layer.borderWidth = 1
            cell.fotoPerfilDono.layer.masksToBounds = true
            cell.fotoPerfilDono.clipsToBounds = true
            
//            print(self.fotoPerfilDono.frame.size.height)
            
            
            cell.fotoPerfilDono.layer.cornerRadius = cell.fotoPerfilDono.frame.width/2
            cell.fotoPerfilDono.layer.borderColor = UIColor(red: 0.42, green: 0.26, blue: 0.13, alpha: 1).CGColor
            
            
            
            
//            self.viewBlur.alpha = 0.8

            
            cell.nomeDono.text =  String(currentAnimal.animalOwner!["name"])
            
            cell.nameAnimal.text = currentAnimal.animalName
            
            
            cell.shareAnimalButton.tag = indexPath.row
            
            
            
            //        print(currentAnimal.animalOwner?.name)
        }
        
        
            
        
        
        
        
        return cell
    }
    
    
    func getData(){
        AnimalDAO.getLostAnimals { (animalsArray, error) -> Void in
            self.animalsArray = animalsArray!
            AnimalDAO.sharedInstance().animalsArray = animalsArray!
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
        
        for index in indexes {
            let cell = self.tableView.cellForRowAtIndexPath(index) as! FeedTableViewCell
            
            if valoresIndex[(valores.indexOf(valores.maxElement()!))!] == index.row{
               UIView.animateWithDuration(3000, animations: { () -> Void in
                cell.theBlur.hidden = true
               })
                
                
            }else{
                UIView.animateWithDuration(3000, animations: { () -> Void in
                    cell.theBlur.hidden = false
                })

            }
        }
    }
    
    @IBAction func compartilharAnimal(sender: AnyObject) {
        print("Compartilhou o mano!!!!")
        
        let button = sender as! UIButton
        let indexPath = NSIndexPath(forRow: button.tag, inSection: 0)
        
        
        print(self.animalsArray[indexPath.row])
        
    }
    
    
    @IBAction func abrirChat(sender: AnyObject) {
        print("Abrir chat com o dono do mano")
    }
    
    @IBAction func abrirContatoDono(sender: AnyObject) {
        print("Abrir contato do dono do mano")
    }
}
