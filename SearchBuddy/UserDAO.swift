//
//  UserDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4


class UserDAO: NSObject {
    
    class func isLogged() -> Bool {
        var result = true
        
        if PFUser.currentUser()?.username == nil{
            result = false
        }else{
            // Do nothing
        }
        
        return result
    }
    
    class func getCurrentUser()-> PFUser? {
        return PFUser.currentUser()
    }
    
    class func loginInternal(username:String, password:String, completion: (sucessed:Bool, error:NSError?) -> Void){
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            var succeded = false
            
            if(user != nil){
                succeded = true
            }
            else{}
            completion(sucessed: succeded,error:error)
        }
    }
    
    class func loginInFacebook(completion: (sucessed:Bool,isNew:Bool, error:NSError?) -> Void){
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: {
            (user: PFUser?, error: NSError?) -> Void in
            var succeded = false
            var isNew = false
            if let user = user {
                if user.isNew {
                    succeded = true
                    isNew = true
                } else {
                    succeded = true
                    isNew = false
                }
            } else {}
            completion(sucessed: succeded,isNew: isNew ,error:error)
        })
    }
    
    class func deleteCurrentUser(completion: (sucessed:Bool,error:NSError?) -> Void){
        let user = self.getCurrentUser()
                
        user?.deleteInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            completion(sucessed: success, error: error)
        }
    }
    
    class func userLogout(){
        PFUser.logOut()
    }
    
    class func updateUserData(user: PFUser, data: Dictionary<String,String>)-> Void{
        
        print(data)
        
        let user = self.getCurrentUser()
                
        user!["name"] = data["name"]
        
        user!["email"] = data["email"]
        
        user?.saveInBackground()
        
    }
    
    class func signUpUser(user: User, completion: (sucessed:Bool, error:NSError?) -> Void){
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            completion(sucessed: succeeded,error:error)
        }
        
    }
    
}
