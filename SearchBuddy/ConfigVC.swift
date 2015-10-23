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
    
    var loginText: UILabel = UILabel()
    var logoutText: UILabel = UILabel()
    
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


    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            switch(indexPath.row) {
                case 0:
                    if UserDAO.isLogged() {
                        return logoutCell
                    }else{
                        return loginCell
                    }
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
}
