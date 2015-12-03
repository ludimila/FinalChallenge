//
//  TypeAnimalDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

class TypeAnimalDAO: SBDAO {
    static private var instance : TypeAnimalDAO?
    
    private var namesType = Array<String>()
    
    private var typeArray = Array<TypeAnimal>()
    
    var allTypes: Array<String>{
        get {
            return Array<String>(self.namesType)
        }
    }
    
    override init () {
        NSException(name: "Singleton", reason: "Use TypeAnimalDAO.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
    }
    
    static func sharedInstance() -> TypeAnimalDAO{
        if instance == nil {
            instance = TypeAnimalDAO(singleton: true)
        }
        return instance!
    }
    
    
    class func getTypes(completion: (Array<TypeAnimal>?, error: NSError?) -> Void){
        let query = TypeAnimal.query()!
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0)) { () -> Void in
            query.findObjectsInBackgroundWithBlock ({ (types, error) -> Void in
                if let typesNN = types as? Array<TypeAnimal>  {
                    completion(typesNN,error: error)
                }else{
                    completion(nil, error: error)
                }
            })
        }
    }
    
    func updateTypeArray(){
        TypeAnimalDAO.getTypes{ (types,error)-> Void in
            self.typeArray = types!
        }
    }

    
//    func getTypeAnimal(completion: ()){
//        
//        let queryType = TypeAnimal.query()
//        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
//        dispatch_async(dispatch_get_global_queue(priority, 0)) { () -> Void in
//            queryType?.findObjectsInBackgroundWithBlock{
//                (objects: [PFObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    print("Successfully retrieved \(objects!.count) scores.")
//                    if let objects = objects {
//                        for object in objects {
//                            let animalType = object as! TypeAnimal
//                            self.namesType.append(animalType.typeDescription!)
//                            
//                            print(animalType.typeDescription)
//                            completion
//                        }
//                    }
//                } else {
//                    print("Error: \(error!) \(error!.userInfo)")
//                }
//                
//            }
//        }
//    }
}
