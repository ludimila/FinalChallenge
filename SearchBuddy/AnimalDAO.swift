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
    
    static private var instance : AnimalDAO?
    
    var animalsArray = Array<Animal>()
    
    var allAnimals: Array<Animal>{
        get {
            return Array<Animal>(self.animalsArray)
        }
    }
    
    var animalsUser = Array<Animal>()
    
    var allAnimalsUser: Array<Animal>{
        get {
            return Array<Animal>(self.animalsUser)
        }
    }
    
    var lostAnimalsUser = Array<Animal>()
    
    var allLostAnimalsUser: Array<Animal>{
        get {
            return Array<Animal>(self.lostAnimalsUser)
        }
    }

    
    override init () {
        NSException(name: "Singleton", reason: "Use AnimalSingleton.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
        self.updateAnimalArray()
    }
    
    static func sharedInstance() -> AnimalDAO {
        if instance == nil {
            instance = AnimalDAO(singleton: true)
        }
        return instance!
    }
    
    class func getLostAnimals(completion: (Array<Animal>?, error: NSError?) -> Void){
        let query = Animal.query()!
//        query?.whereKey("autor", equalTo: usuario)
        query.orderByDescending("createdAt")
        
        let queryStatus = StatusAnimal.query()
        queryStatus!.whereKey("objectId", equalTo: "06cg0yLSSl")
        
        queryStatus!.findObjectsInBackgroundWithBlock { (status, error) -> Void in
            query.whereKey("animalStatus", containedIn: status!)
            
            query.includeKey("animalStatus")
            query.includeKey("animalType")
            query.includeKey("animalOwner")
            
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                query.findObjectsInBackgroundWithBlock ({ (animals, error) -> Void in
                    for animal in animals!{
                        animal.fetchIfNeededInBackground()
                    }
                    
                    
                    
                    if let animalsNN = animals as? Array<Animal> {
                        AnimalDAO.sharedInstance().animalsArray = animalsNN
                        completion(animalsNN, error: error)
                        
                    }else{
                        completion(nil, error: error)
                    }
                })
                
                
            }
        }
        
        
        
    }
    
    
    class func getAnimalsFromUser(user: User, completion: () -> Void){
        
        let query = Animal.query()!
        
        
        query.whereKey("animalOwner", equalTo: user)
        
        query.orderByDescending("createdAt")
        
        query.includeKey("animalStatus")
        query.includeKey("animalType")
        query.includeKey("animalOwner")
        
        
        query.findObjectsInBackgroundWithBlock { (animals, error) -> Void in
            if error == nil {
                for animal in animals!{
                    animal.fetchIfNeededInBackground()
                }
                
                
                AnimalDAO.sharedInstance().animalsUser = Array<Animal>()
                for animal in animals! {
                    let animal = animal as! Animal
                    
                    AnimalDAO.sharedInstance().animalsUser.append(animal)
                }
                
                completion()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    class func getLostAnimalsFromUser(user: User, completion: () -> Void){
        
        let query = Animal.query()!
        
        let queryStatus = StatusAnimal.query()
        queryStatus!.whereKey("objectId", equalTo: "m2WkU7UWDg")
        queryStatus!.findObjectsInBackgroundWithBlock { (status, error) -> Void in
            query.whereKey("animalStatus", containedIn: status!)
            query.whereKey("animalOwner", equalTo: user)
            
            query.orderByDescending("createdAt")
            query.includeKey("animalStatus")
            query.includeKey("animalType")
            query.includeKey("animalOwner")
            
            
            query.findObjectsInBackgroundWithBlock { (animals, error) -> Void in
                if error == nil {
                    for animal in animals!{
                        animal.fetchIfNeededInBackground()
                }
                    AnimalDAO.sharedInstance().lostAnimalsUser = Array<Animal>()
                    for animal in animals! {
                        let animal = animal as! Animal
                        AnimalDAO.sharedInstance().lostAnimalsUser.append(animal)
                    }
                    completion()
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }
    
    
    class func signUpAnimal(animal: Animal, completion: (sucessed:Bool, error:NSError?) -> Void){
        animal.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            completion(sucessed: succeeded,error:error)
        })
    }
    
    func updateAnimalArray(){
        AnimalDAO.getLostAnimals{ (animals,error)-> Void in
            self.animalsArray = animals!
        }
    }

}