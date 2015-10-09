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

    
    static func loginClick(viewController: UIViewController)->Void{
        let readPermissions = ["public_profile","email"]
        
        FBSDKLoginManager().logInWithReadPermissions(readPermissions, fromViewController: viewController, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil{
                print("\(error.description)")
            }else{
                print("\(result.token.userID)")
            }
        })
    }
    
    class func login(){
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile"], block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
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