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
        
        

        let currentAnimal : Animal = self.animalsArray[indexPath.row]
        print(currentAnimal.animalOwner)
        
        
        cell.fotoPerfilDono.image = UIImage(named: "dog")
        cell.nomeDono.text = currentAnimal.animalOwner?.name
        
        cell.nameAnimal.text = currentAnimal.animalName
        
        
        cell.shareAnimalButton.tag = indexPath.row
        
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
            let cell = self.tableView.cellForRowAtIndexPath(index)
            
            if valoresIndex[(valores.indexOf(valores.maxElement()!))!] == index.row{
                cell?.alpha = 1
            }else{
                cell?.alpha = 0.5
            }
        }
    }
    
    @IBAction func compartilharAnimal(sender: AnyObject) {
        print("Compartilhou o mano!!!!")
        
        let button = sender as! UIButton
        let indexPath = NSIndexPath(forRow: button.tag, inSection: 0)
        
        
        let cellAnimalSelecionado = self.tableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell
        
        print(cellAnimalSelecionado.nameAnimal.text)
        
    }
    
    
    @IBAction func abrirChat(sender: AnyObject) {
        print("Abrir chat com o dono do mano")
    }
    
    @IBAction func abrirContatoDono(sender: AnyObject) {
        print("Abrir contato do dono do mano")
    }
}
