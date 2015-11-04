//
//  UserVC.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 29/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class UserVC: UIViewController, UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var telefone: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.nome.delegate = self
        self.telefone.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tirarFoto(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        
        if ( UIImagePickerController.isSourceTypeAvailable(.Camera)){
            imagePicker.sourceType = .Camera
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imageView.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        if ( string == "") {
            return true
        }
        
        if (textField .isEqual(self.telefone)){
            
            if(textField.text?.characters.count == 4){
                
                textField.text = textField.text!.stringByAppendingFormat("-")
                
            }else if (textField.text?.characters.count > 8){
                
                textField.text = textField.text?.substringToIndex((textField.text?.endIndex)!)
                
            }
            
            
        }
        return true
    }
    
    @IBAction func saveUser(sender: AnyObject) {
        
        /* Necessário recuperar o usuário do FaceBook ou já logado
        e verificar como apenas editar o usuário
        
        
        
        */
        
        // Usuário a partir do Parse
        let currentUser = User.currentUser()
        
        currentUser?.refreshInBackgroundWithBlock({ (object,error) -> Void in
            
            
            print("Refreshed")
            currentUser?.fetchIfNeededInBackgroundWithBlock({ (result, error) -> Void in
                
                
                currentUser?.name = self.nome.text
                currentUser?.userPhoneNumber = self.telefone.text
                currentUser?.userPicture = self.imageView.image
                
                
                print("Updated")
            })
            
        })
        
        
        /*
        let user = User()
        
        
        user.name = nome.text
        user.userPhoneNumber = telefone.text
        user.userPicture = imageView.image
        user.city = "";
        user.state = "";
        
        
        */
        
        
        
        
        
        print("Salvei usuário");
        
    }
    
    @IBAction func backUser(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
