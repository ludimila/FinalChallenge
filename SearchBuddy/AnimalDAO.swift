//
//  AnimalDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

class AnimalDAO: SBDAO {
    
    class func getLostAnimals(completion: (Array<Animal>?, error: NSError?) -> Void){
        let query = Animal.query()!
//        query?.whereKey("autor", equalTo: usuario)
        query.orderByDescending("createdAt")
        
        query.includeKey("animalStatus")
        query.includeKey("animalType")
        query.includeKey("animalOwner")
    
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            query.findObjectsInBackgroundWithBlock ({ (animals, error) -> Void in
                if let animalsNN = animals as? Array<Animal> {
                    completion(animalsNN, error: error)
                }else{
                    completion(nil, error: error)
                }
            })
        }
        
    }
    
}