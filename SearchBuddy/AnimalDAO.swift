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
    
    static private var instance: AnimalDAO?
    private var animalsArray = Array<Animal>()
    
    var allAnimals : Array<Animal> {
        get{
            return Array<Animal>(self.animalsArray)
        }
    }
        
    override init () {
        NSException(name: "Singleton", reason: "Use AnimalDAO.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
        self.getAllAnimals()        
    }
    
    static func sharedInstance() -> AnimalDAO {
        if instance == nil {
            instance = AnimalDAO(singleton: true)
        }
        return instance!
    }
    
    private func getAllAnimals() -> Void{
        let query = PFQuery(className:"Animal")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (animals: [PFObject]?, error: NSError?) -> Void in
            if error != nil {
                print("\(error?.description)")
            }
            print("\(animals)")
            for oneAnimal in animals! {
                    let animal: Animal = Animal()
                    animal.animalName = oneAnimal["animalName"] as? String
                    animal.breed = oneAnimal["breed"] as? String
                    animal.vaccinated = oneAnimal["vacinated"] as? NSNumber
                    animal.animalDescription = oneAnimal["animalDescription"] as? String
                    
                    self.animalsArray.append(animal)
                }
        }
    }
}