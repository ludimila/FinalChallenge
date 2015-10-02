//
//  UserDAO.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/2/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class UserDAO: SBDAO {
    static private var instance: UserDAO?
    
    var currentUser: User!
    
    override init () {
        NSException(name: "Singleton", reason: "Use UserDAO.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
    }
    
    static func sharedInstance() -> UserDAO {
        if instance == nil {
            instance = UserDAO(singleton: true)
        }
        return instance!
    }
    
}
