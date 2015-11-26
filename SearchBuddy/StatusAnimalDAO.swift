//
//  StatusAnimalDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class StatusAnimalDAO: SBDAO {
    
    static private var instance : StatusAnimalDAO?
    
    var statusArray = Array<StatusAnimal>()
    
    var allStatus: Array<StatusAnimal>{
        get {
            return Array<StatusAnimal>(self.statusArray)
        }
    }
    
    override init () {
        NSException(name: "Singleton", reason: "Use AnimalSingleton.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
        self.updateStatusArray()
    }
    
    static func sharedInstance() -> StatusAnimalDAO {
        if instance == nil {
            instance = StatusAnimalDAO(singleton: true)
        }
        return instance!
    }

    
    class func getStatus(completion: (Array<StatusAnimal>?, error: NSError?) -> Void){
        let query = StatusAnimal.query()!
        query.orderByDescending("createdAt")
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            query.findObjectsInBackgroundWithBlock ({ (status, error) -> Void in
                if let statusNN = status as? Array<StatusAnimal>  {
                    completion(statusNN,error: error)
                }else{
                    completion(nil, error: error)
                }
            })
        }
    }
    
    func updateStatusArray(){
        StatusAnimalDAO.getStatus{ (status,error)-> Void in
            self.statusArray = status!
        }
    }
}
