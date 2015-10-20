//
//  UserDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

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
    
    class func userLogout(){
        PFUser.logOut()
    }
    
    class func signUpUser(user: User, completion: (sucessed:Bool, error:NSError?) -> Void){
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            completion(sucessed: succeeded,error:error)
        }
        
    }
    
}
