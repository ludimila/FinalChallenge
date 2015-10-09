//
//  ProfileVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/7/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    var currentUserName = "Anonimo" as String
    
    @IBOutlet weak var helloUser: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(UserDAO.isLogged())")
    }

    @IBAction func login(sender: AnyObject) {
        FacebookParse.login()
    }
    
    func changeTextIfLogged(){
        
    }
    
}
