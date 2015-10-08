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
    }

    @IBAction func login(sender: AnyObject) {
        if UserDAO.getCurrentUser() == nil{
            let result = FacebookParse.facebookLoginWithResult()
            if result{
                loginButton.titleLabel?.text = "Logout"
                currentUserName = (UserDAO.getCurrentUser()?.username)!
                helloUser.text = "Olá " + currentUserName
            }else{
                //Do nothing
            }
        }else{
            UserDAO.userLogout()
            currentUserName = "Anonimo"
            loginButton.titleLabel?.text = "Login"
            helloUser.text = "Olá " + currentUserName
            
        }
    }
    
}
