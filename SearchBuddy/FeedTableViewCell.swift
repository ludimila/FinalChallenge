//
//  FeedTableViewCell.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 04/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    let blackView = UIView()


    @IBOutlet weak var fotoPerfilDono: UIImageView!
    @IBOutlet weak var nomeDono: UILabel!
    @IBOutlet weak var fotoAnimal: UIImageView!
    @IBOutlet weak var nameAnimal: UILabel!
    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var animalSituation: UILabel!
    @IBOutlet weak var theBlur: UIVisualEffectView!
    
    @IBOutlet weak var shareAnimalButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var viewBlur: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        self.fotoPerfilDono.layer.borderWidth = 1
        self.fotoPerfilDono.layer.masksToBounds = true
        self.fotoPerfilDono.clipsToBounds = true
        
        print(self.fotoPerfilDono.frame.size.height)
        
        
        self.fotoPerfilDono.layer.cornerRadius = self.fotoPerfilDono.frame.width/2
        self.fotoPerfilDono.layer.borderColor = UIColor(red: 0.42, green: 0.26, blue: 0.13, alpha: 1).CGColor
        
        
        self.viewBlur.alpha = 0.8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    func hiddenBlackView(){
    
        self.blackView.hidden = true
        self.layoutIfNeeded()
        
    }
    
}
