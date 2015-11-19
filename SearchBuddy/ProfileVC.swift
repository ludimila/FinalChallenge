//
//  ProfileVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/20/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableviewIsEmptylb: UILabel!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var ocupacao: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var telefoneDonoLb: UILabel!
    @IBOutlet weak var localizacaoDonoLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.bounces = false
        
        self.backImage.image = UIImage(named: "arches-945495_1920.jpg")
        
        self.background.backgroundColor = UIColor(red:0.49, green:0.91, blue:1.00, alpha:0.8)
        
        self.tableView.separatorColor = UIColor.orangeColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Perfil"
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        if let nomeUsuario = UserDAO.getCurrentUser()!["name"] {
            self.nome.text = nomeUsuario as? String
        }else{
            self.nome.text = "Sem nome"
        }
        
        if let telefoneUsuario = UserDAO.getCurrentUser()!["userPhoneNumber"] {
            self.telefoneDonoLb.text = telefoneUsuario as? String
        }else{
            self.telefoneDonoLb.text = ""
        }
        
        
//        Aqui pegara a cidade a respeito do cgpoint presente no user
        self.localizacaoDonoLb.text = "Brasilia"
        
        
        AnimalDAO.getAnimalsFromUser { () -> Void in
            self.tableView.reloadData()
            
            if AnimalDAO.sharedInstance().allAnimalsUser.count > 0{
                print("MAIOR")
                self.tableView.hidden = false
                self.tableviewIsEmptylb.hidden = true
            }else{
                print("MENOR")
                self.tableView.hidden = true
                self.tableviewIsEmptylb.hidden = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Utilities.round(self.imageView, tamanhoBorda: 2)
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimalDAO.sharedInstance().allAnimalsUser.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let animal = AnimalDAO.sharedInstance().allAnimalsUser[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
        
        
        if (cell.respondsToSelector("setPreservesSuperviewLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.075
    }
    
    
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
