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
        UserDAO.loginInFacebook() { (sucessed,isNew,error) -> Void in
            if sucessed{
                if isNew{
                    let alert = UIAlertController(title: "Cadastro Realizado", message: "Bem-vindo. Seu cadastro foi realizado com o Facebook", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: {})
                }else{
                    let alert = UIAlertController(title: "Login realizado", message: "Bem vindo de volta", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: {})
                }
                
            }else{
                let alert = UIAlertController(title: "Erro no Login", message: "O login foi cancelado", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in }
                alert.addAction(action)
            }
        }
    }
    func changeTextIfLogged(){
        
    }
}
