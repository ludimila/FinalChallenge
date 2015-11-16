//
//  ParseConvertion.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 11/16/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

class ParseConvertion: NSObject {

    class func imageToPFFile(image: UIImage) -> PFFile{
        return PFFile(data: UIImagePNGRepresentation(image)!)
    }
    
}
