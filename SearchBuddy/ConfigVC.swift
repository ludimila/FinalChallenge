//
//  ConfigVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/22/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class ConfigVC: UITableViewController {

    var loginCell: UITableViewCell = UITableViewCell()
    var logoutCell: UITableViewCell = UITableViewCell()
    var deleteCell: UITableViewCell = UITableViewCell()
    
    var loginText: UILabel = UILabel()
    var logoutText: UILabel = UILabel()
    var deleteText: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginText = UILabel(frame: CGRectInset(self.loginCell.contentView.bounds, 15, 0))
        self.loginText.text = "Login"
        self.loginCell.addSubview(self.loginText)
        self.loginCell.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)
        
        
        self.logoutText = UILabel(frame: CGRectInset(self.logoutCell.contentView.bounds, 15, 0))
        self.logoutText.text = "Logout"
        self.logoutCell.addSubview(self.logoutText)
        self.logoutCell.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
        
        self.deleteText = UILabel(frame: CGRectInset(self.deleteCell.contentView.bounds,15,9))
        self.deleteText.text = "Deletar conta"
        self.deleteCell.addSubview(self.deleteText)
        self.deleteCell.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)

    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Configurações"
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
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
                
                default: fatalError("Unknown row in section 0")
            }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
}
