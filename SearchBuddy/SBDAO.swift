//
//  SBDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SBDAO: NSObject {
    
    static func setupParse(options:[NSObject: AnyObject]?) {
        Parse.setApplicationId("rImNRnbETYGRjs9LotPmKIxD483RymlWk3BYJnKt", clientKey: "cJfXcVYG5VyLfLuAirXaCS5U9AdYKukhmA8HFfz1")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(options)
    }

}
