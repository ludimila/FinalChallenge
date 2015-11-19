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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var tableViewToReload:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        print("\(UserDAO.isLogged())")
        self.reloadInputViews()
    }


    @IBAction func loginInterno(sender: AnyObject) {
        
        UserDAO.loginInternal(usernameField.text!, password: passwordField.text!) { (sucessed, error) -> Void in
            if sucessed{
                let alert = UIAlertController(title: "Login Realizado", message: "Bem vindo de volta", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    self.tableViewToReload!.reloadData()
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: {})
            }else{
                print("TEM QUE TA")
                let alert = UIAlertController(title: "Erro no Login", message: "O login foi cancelado", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: {})

            }
        }
    }
    
    
    @IBAction func facebookLogin(sender: AnyObject) {
        UserDAO.loginInFacebook() { (sucessed,isNew,error) -> Void in
            if sucessed{
                if isNew{
                    var userData = Dictionary<String,String>()
                    FacebookParse.getFBUserData({ (sucessed, data, error) -> Void in
                        if error == nil{
                            userData = data
                            print("AEEEEHOOOOOOOOOO")
                            
                            let user = UserDAO.getCurrentUser()
                            
                            UserDAO.updateUserData(user!, data: userData)
                            
                            let alert = UIAlertController(title: "Cadastro Realizado", message: "Bem-vindo. Seu cadastro foi realizado com o Facebook", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default) { _ in

                                self.tableViewToReload!.reloadData()
                            }
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: {})

                        }
                    })
                }else{
                    let alert = UIAlertController(title: "Login realizado", message: "Bem vindo de volta", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        self.tableViewToReload!.reloadData()
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: {})
                }
                
            }else{
                let alert = UIAlertController(title: "Erro no Login", message: "O login foi cancelado", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: {})
            }
        }
    }
}
