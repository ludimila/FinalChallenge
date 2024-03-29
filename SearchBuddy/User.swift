//
//  User.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    
    @NSManaged var userPicture: PFFile?
    @NSManaged var userPhoneNumber: String?
    @NSManaged var name: String?
    @NSManaged var bairro: String?
    @NSManaged var cidade: String?
    @NSManaged var locationUser: PFGeoPoint?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
}
