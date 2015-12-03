//
//  RegisterVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/20/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController{

    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldUser: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    
    var tableViewToReload:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // The number of columns of data
    
    @IBAction func doRegister(sender: AnyObject) {
        let user = User()
        user.name = fieldName.text
        user.username = fieldUser.text
        user.password = fieldPassword.text
        
        UserDAO.signUpUser(user) { (sucessed,error) -> Void in
            if sucessed{
                let alert = UIAlertController(title: "Cadastro Realizado", message: "Bem-vindo \(user.name). Seu cadastro foi realizado com sucesso", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    self.tableViewToReload?.reloadData()
                    if self.navigationController == nil{
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                            self.presentViewController(storyBoard!, animated: true, completion: nil)
                    }else{
                        let tabBar = self.navigationController?.parentViewController as! UITabBarController
                        tabBar.selectedIndex = 1
                    }
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: {})
            }else{
                let errorString = error!.userInfo["error"] as? NSString
                let alert = UIAlertController(title: "Falha no cadastro", message: "Erro: \(errorString!)", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: {})
            }
        }
    }
}
