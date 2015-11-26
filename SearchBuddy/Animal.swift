//
//  Animal.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

class Animal: PFObject, PFSubclassing{
    
    @NSManaged var animalName: String?
    @NSManaged var breed: String?
    @NSManaged var vaccinated: NSNumber?
    @NSManaged var animalDescription: String?
    @NSManaged var animalPicture: PFFile?
    @NSManaged var animalType: TypeAnimal?
    @NSManaged var animalStatus: StatusAnimal?
    @NSManaged var animalOwner: User?
    @NSManaged var local: PFGeoPoint?
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Animal"
    }

    
}
