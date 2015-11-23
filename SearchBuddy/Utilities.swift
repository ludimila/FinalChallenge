//
//  Utilities.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 11/19/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    class func round(view: UIView, tamanhoBorda: CGFloat) -> Void {
        view.contentMode = UIViewContentMode.ScaleAspectFill
        view.layer.borderWidth = tamanhoBorda
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.size.width / 2
        view.layer.masksToBounds = true
        
    }
    
}
