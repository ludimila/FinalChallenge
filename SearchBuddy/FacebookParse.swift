//
//  FacebookParse.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/7/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class FacebookParse: NSObject {
    
    class func facebookLogin(){
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile"]) {
            (user: PFUser?, error: NSError?) -> Void in
            print("\(user)")
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    class func unlinkUserToFacebook(user: PFUser){
        PFFacebookUtils.unlinkUserInBackground(user, block: {
            (succeeded: Bool, error: NSError?) -> Void in
            if (succeeded) {
                print("The user is no longer associated with their Facebook account.")
            }
        })
    }
    
    class func linkUserToFacebook(user: PFUser){
        if !PFFacebookUtils.isLinkedWithUser(user) {
            PFFacebookUtils.linkUserInBackground(user, withReadPermissions: nil, block: {
                (succeeded: Bool, error: NSError?) -> Void in
                if succeeded {
                    print("Woohoo, the user is linked with Facebook!")
                }
            })
        }
        else{
            print("Oh man, this user is already linked to facebook!!!")
        }
    }
}