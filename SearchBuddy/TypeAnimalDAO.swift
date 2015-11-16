//
//  TypeAnimalDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class TypeAnimalDAO: SBDAO {
    static private var instance : TypeAnimalDAO?
    
    private var typeArray = Array<TypeAnimal>()
    
    var allTypes: Array<TypeAnimal>{
        get {
            return Array<TypeAnimal>(self.typeArray)
        }
    }
    
    override init () {
        NSException(name: "Singleton", reason: "Use TypeAnimalDAO.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
        self.updateTypeArray()
    }
    
    static func sharedInstance() -> TypeAnimalDAO{
        if instance == nil {
            instance = TypeAnimalDAO(singleton: true)
        }
        return instance!
    }
    
    
    class func getTypes(completion: (Array<TypeAnimal>?, error: NSError?) -> Void){
        let query = StatusAnimal.query()!
        query.orderByDescending("createdAt")
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
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

}
