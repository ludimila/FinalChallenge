//
//  AnimalSingleton.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 27/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalSingleton: NSObject {

    static private var instance : AnimalSingleton?
    
    
    
    var animalsArray = Array<Animal>()
    
    override init () {
        NSException(name: "Singleton", reason: "Use AnimalSingleton.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
    }
    
    static func sharedInstance() -> AnimalSingleton {
        if instance == nil {
            instance = AnimalSingleton(singleton: true)
        }
        return instance!
    }
    
    
}
