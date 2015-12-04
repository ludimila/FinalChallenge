
//
//  FeedVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 04/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import MapKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var teste = Int()
    
    
    @IBOutlet weak var tableView: UITableView!
//    var animalsArray = Array<Animal>()
    
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
        
        self.tableView.estimatedRowHeight = 700
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        
        self.refreshTableView!.addTarget(self, action: "reloadTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshTableView!)
        
        loadCustomRefreshContent()
        
        if Reachability.testConnection(){
            getData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func reloadTableView() {
        
        self.refreshTableView!.endRefreshing()

        if Reachability.testConnection(){
            getData()
        }
    }
    
    func loadCustomRefreshContent() {
//        let refreshContets = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
//        
//        self.customView = refreshContets[0] as! UIView
//        self.customView.frame = self.refreshTableView!.bounds
//        
//        for var i=0; i<customView.subviews.count; i++ {
//            labelsArray.append(self.customView.viewWithTag(i + 1) as! UILabel)
//        }
//        
//        self.refreshTableView!.addSubview(self.customView)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimalDAO.sharedInstance().allAnimals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        if let currentAnimal : Animal = AnimalDAO.sharedInstance().allAnimals[indexPath.row]{
            
            currentAnimal.animalPicture?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil{
                    cell.fotoAnimal.image = UIImage(data: data!)
                }else{
                    print(error?.description)
                }
            })
            
            
            
            if currentAnimal.animalOwner!.userPicture != nil{
                currentAnimal.animalOwner!.userPicture!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        cell.fotoPerfilDono.image = UIImage(data: data!)
                    }
                })
            }else{
                cell.fotoPerfilDono.image = UIImage(named: "FotoPerfilVazio")
            }
            
            Utilities.round(cell.fotoPerfilDono, tamanhoBorda: 1)
            cell.fotoPerfilDono.layer.borderColor = UIColor(red: 0.42, green: 0.26, blue: 0.13, alpha: 1).CGColor
            
            cell.nomeDono.text =  String(currentAnimal.animalOwner!["name"])
            
            cell.ultimaVezVisto.text = self.getDateDifference(currentAnimal.ultimaVezVisto!)
            
            cell.nameAnimal.text = currentAnimal.animalName
            
            cell.descricao.text = currentAnimal.animalDescription
            
//            cell.shareAnimalButton.tag = indexPath.row
            cell.phoneButton.tag = indexPath.row
//            cell.chatButton.tag = indexPath.row
        }
        
        if (cell.respondsToSelector("setPreservesSuperviewLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        return cell
    }
    
    func getData(){
        AnimalDAO.getLostAnimals { (animalsArray, error) -> Void in
            self.tableView.reloadData()
        }

    }
    
    func getDateDifference(dataUltimavez: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let startDate = dataUltimavez
        let endDate = NSDate()
        
        let cal = NSCalendar.currentCalendar()
        
        let componentsMonth = cal.components(NSCalendarUnit.Month, fromDate: startDate, toDate: endDate, options: NSCalendarOptions.WrapComponents)
        let componentsMinute = cal.components(NSCalendarUnit.Minute, fromDate: startDate, toDate: endDate, options: NSCalendarOptions.WrapComponents)
        
        
        var string = String()
        
        if (componentsMinute.minute/60) < 1{
            string = "Perdido há \(componentsMinute.minute) minutos."
        }else if (componentsMinute.minute/1440) < 1{
            string = "Perdido há \((componentsMinute.minute/60)) hora(s)."
        }else if componentsMonth.month < 1{
            string = "Perdido há \((componentsMinute.minute/1440)) dia(s)."
        }else{
            string = "Perdido há \(componentsMonth.month) mes(es)."
        }
        
        
        return string
    }
    
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let indexes = self.tableView.indexPathsForVisibleRows as Array!
//        
//        
//        var valores = Array<CGFloat>()
//        var valoresIndex = Array<Int>()
//        
//        for index in indexes {
//            
//            let cellTeste = self.tableView.cellForRowAtIndexPath(index)
//            let rectInTableView = self.tableView.rectForRowAtIndexPath(index)
//            let rectInSuperview = self.tableView.convertRect(rectInTableView, toView: self.tableView.superview)
//            
//            var cellAmoutTela = (-30 + rectInSuperview.origin.y + (cellTeste?.frame.size.height)!)
//            
//            
//            if cellAmoutTela > cellTeste?.frame.size.height{
//                cellAmoutTela = (self.tableView.frame.size.height - (-30 + rectInSuperview.origin.y))
//            }
//            
//            
//            valoresIndex.append(index.row)
//            valores.append(cellAmoutTela)
//        }
//        
//        for index in indexes {
//            let cell = self.tableView.cellForRowAtIndexPath(index) as! FeedTableViewCell
//            
//            if valoresIndex[(valores.indexOf(valores.maxElement()!))!] == index.row{
//               UIView.animateWithDuration(3000, animations: { () -> Void in
//                cell.theBlur.hidden = true
//               })
//                
//                
//            }else{
//                UIView.animateWithDuration(3000, animations: { () -> Void in
//                    cell.theBlur.hidden = false
//                })
//
//            }
//        }
//    }
    
//    @IBAction func compartilharAnimal(sender: AnyObject) {
//        print("Compartilhou o mano!!!!")
//        
//        let button = sender as! UIButton
//        let indexPath = NSIndexPath(forRow: button.tag, inSection: 0)
//        
//        
//        //print(AnimalDAO.sharedInstance().allAnimals[indexPath.row])
//        
//    }
//    
//    
//    @IBAction func abrirChat(sender: AnyObject) {
//        print("Abrir chat com o dono do mano")
//    }
//    
    @IBAction func abrirContatoDono(sender: AnyObject) {
        let animal = AnimalDAO.sharedInstance().allAnimals[sender.tag]
        let phoneNumber = animal.animalOwner?.userPhoneNumber
        
        let string = "tel://\(phoneNumber!)"
        
        print(string)
        let url:NSURL = NSURL(string: string)!
        UIApplication.sharedApplication().openURL(url)
    }
}
