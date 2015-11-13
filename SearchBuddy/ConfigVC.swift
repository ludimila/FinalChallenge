//
//  ConfigVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/22/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class ConfigVC: UITableViewController {

    var enableCell: UITableViewCell = UITableViewCell()
    var rangeCell: UITableViewCell = UITableViewCell()
    var loginCell: UITableViewCell = UITableViewCell()
    var logoutCell: UITableViewCell = UITableViewCell()
    var deleteCell: UITableViewCell = UITableViewCell()
    
    var loginText: UILabel = UILabel()
    var logoutText: UILabel = UILabel()
    var deleteText: UILabel = UILabel()
    var rangeText: UILabel = UILabel()
    var enableText: UILabel = UILabel()
    
    
    var isEnableControl: UISwitch = UISwitch()
    var rangeSlider : UISlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enableText = UILabel(frame: CGRectInset(self.loginCell.contentView.bounds, 15, 0))
        self.enableText.text = "Enable Notification"
        self.enableCell.addSubview(self.enableText)
        self.enableCell.addSubview(self.isEnableControl)
        self.enableCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.addConstraintsToEnableCell()

        
        self.rangeText = UILabel(frame: CGRectInset(self.loginCell.contentView.bounds, 15, 0))
        self.rangeText.text = "Edit range"
        self.rangeCell.addSubview(self.rangeSlider)
        self.rangeCell.addSubview(self.rangeText)
        self.rangeCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.addConstraintsToRangeCell()

        
        self.loginText = UILabel(frame: CGRectInset(self.loginCell.contentView.bounds, 15, 0))
        self.loginText.text = "Login"
        self.loginCell.addSubview(self.loginText)
        self.loginCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        
        self.logoutText = UILabel(frame: CGRectInset(self.logoutCell.contentView.bounds, 15, 0))
        self.logoutText.text = "Logout"
        self.logoutCell.addSubview(self.logoutText)
        
        self.deleteText = UILabel(frame: CGRectInset(self.deleteCell.contentView.bounds,15,9))
        self.deleteText.text = "Deletar conta"
        self.deleteCell.addSubview(self.deleteText)

    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Configurações"
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
        switch (indexPath.section){
        case 0:
            switch(indexPath.row){
            case 0:
                return enableCell
            case 1:
                return rangeCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0:
                if UserDAO.isLogged() {
                    return logoutCell
                }else{
                    return loginCell
                }
            case 1:
                if UserDAO.isLogged() == false{
                    self.deleteCell.hidden = true
                }
                else{
                    self.deleteCell.hidden = false
                }
                return deleteCell
                
            default: fatalError("Unknown row in section 1")
            }
            
        default: fatalError("Unknown section in tableView")
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch(indexPath.section){
        case 0: break
            
        case 1:
            switch(indexPath.row) {
            case 0:
                if UserDAO.isLogged() {
                    print("LOGUI AUTI")
                    UserDAO.userLogout()
                    tableView.reloadData()
                }else{
                    print("LOGUI IN")
                    performSegueWithIdentifier("toLogin", sender: self)
                }
            case 1:
                let alert = UIAlertController(title: "CUIDADO", message: "Você tem certeza que deseja deletar todos os seus dados?", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    self.callDeleteFunction()
                    self.tableView!.reloadData()
                }
                let action2 = UIAlertAction(title: "Cancelar", style: .Default){ _ in
                    print("cancela tudo carai")
                }
                alert.addAction(action)
                alert.addAction(action2)
                self.presentViewController(alert, animated: true, completion: {})
                
            default: fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown row in section 0")
        }
         }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toLogin"{
            if let nextController = segue.destinationViewController as? PresentationVC{
                nextController.tableViewToReload = self.tableView
            }
        }
    }
    
    func callDeleteFunction(){
        UserDAO.deleteCurrentUser({ (sucessed, error) -> Void in
            if sucessed == true{
                let alert = UIAlertController(title: "Usuario Deletado", message: "O seu usuário foi deletado com sucesso", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    UserDAO.userLogout()
                    self.tableView!.reloadData()
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: {})
                
            }else{
                print(error)
                let alert = UIAlertController(title: "Erro", message: "O seu usuário não foi deletado devido a um error", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    self.tableView!.reloadData()
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: {})
            }
        })
    }
    
    
    func addConstraintsToRangeCell(){
        self.rangeText.translatesAutoresizingMaskIntoConstraints = false
        self.rangeSlider.translatesAutoresizingMaskIntoConstraints = false

        let constLabel1 = NSLayoutConstraint(item: self.rangeText, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.rangeCell, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        
        let constLabel2 = NSLayoutConstraint(item: self.rangeText, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.rangeCell, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
        
        let const1 = NSLayoutConstraint(item: self.rangeSlider, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.rangeCell, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: -20)
        
        let const2 = NSLayoutConstraint(item: self.rangeSlider, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.rangeCell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

        
        NSLayoutConstraint.activateConstraints([constLabel1,constLabel2,const1,const2])

    }
    
    func addConstraintsToEnableCell(){
        self.isEnableControl.translatesAutoresizingMaskIntoConstraints = false
        self.enableText.translatesAutoresizingMaskIntoConstraints = false
        
        let constLabel1 = NSLayoutConstraint(item: self.enableText, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.enableCell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        let constLabel2 = NSLayoutConstraint(item: self.enableText, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.enableCell, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
        
        let const1 = NSLayoutConstraint(item: self.enableCell, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.isEnableControl, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10)
        
        let const2 = NSLayoutConstraint(item: self.enableCell, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.isEnableControl, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activateConstraints([constLabel1,constLabel2,const1,const2])
    }
}
