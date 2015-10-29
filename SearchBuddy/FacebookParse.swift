//
//  FacebookParse.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/7/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookParse: NSObject {
    
    var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
    let fileManager = NSFileManager.defaultManager()
    
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
    
    internal func getFBUserData() -> Void {
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, friends"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    
                    
//                    var idFB = result.objectForKey("id") as! String
//                    // Get the user's profile picture.
//                    var picture = result.objectForKey("picture") as! NSDictionary
//                    var data = picture.objectForKey("data") as! NSDictionary
//                    var url = data.objectForKey("url") as! String
//                    
//                    var pictureURL : NSURL = NSURL(string: url)!
//                    var pictureImage = UIImage(data: NSData(contentsOfURL: pictureURL)!)
//                    
//                    
//                    var filePathToWrite = "\(self.paths)/\(idFB)"
//                    var imageData: NSData = UIImagePNGRepresentation(pictureImage!)!
//                    self.fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
                    
                } else {
                    print("\(error)")
                }
            })
        }
    }

}