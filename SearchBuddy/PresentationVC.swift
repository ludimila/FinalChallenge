//
//  PresentationVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/23/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class PresentationVC: UIViewController {
    
    var tableViewToReload:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginScreen"{
            if let nextController = segue.destinationViewController as? LoginVC{
                nextController.tableViewToReload = self.tableViewToReload!
            }
        }else if segue.identifier == "registerScreen"{
            if let nextController = segue.destinationViewController as? RegisterVC{
                nextController.tableViewToReload = self.tableViewToReload
            }
        }
    }
    
    
    


}
