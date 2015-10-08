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
    
    class func getCurrentUser()-> PFUser? {
        return PFUser.currentUser()
    }
    
    class func userLogout(){
        PFUser.logOut()
    }
}
