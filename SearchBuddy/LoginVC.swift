//
//  ProfileVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/7/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    var currentUserName = "Anonimo" as String
    
    @IBOutlet weak var helloUser: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        print("\(UserDAO.isLogged())")
        self.reloadInputViews()
    }


    @IBAction func loginInterno(sender: AnyObject) {
    }
    
    @IBAction func twitterLogin(sender: AnyObject) {
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        FacebookParse.loginClick(self)
    }
    
    func changeTextIfLogged(){
        
    }
    
}
