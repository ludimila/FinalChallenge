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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
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
        /*
        if (textField .isEqual(self.telefone)){
            
            if(textField.text?.characters.count == 4){
                
                textField.text = textField.text!.stringByAppendingFormat("-")
                
            }else if (textField.text?.characters.count > 8){
                
                textField.text = textField.text?.substringToIndex((textField.text?.endIndex)!)
                
            }
            
            
        }
        */
        return true
    }
    
    @IBAction func saveUser(sender: AnyObject) {
        
        
        
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
