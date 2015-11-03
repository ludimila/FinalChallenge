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
    
        query.findObjectsInBackgroundWithBlock ({ (animals, error) -> Void in
            if let animalsNN = animals as? Array<Animal> {
                completion(animalsNN, error: error)
            }else{
                completion(nil, error: error)
            }
        })
    }
    
    
    class func signUpAnimal(animal: Animal, completion: (sucessed:Bool, error:NSError?) -> Void){
        
        animal.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            completion(sucessed: succeeded,error:error)
        })
        

    
    
    
    }
}