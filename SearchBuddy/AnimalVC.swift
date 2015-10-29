//
//  AnimalVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 27/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalBreed: UILabel!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.animalPicture.layer.borderWidth = 2.0
//        self.animalPicture.layer.masksToBounds = true
//        self.animalPicture.layer.borderColor = UIColor.brownColor().CGColor
//        self.animalPicture.layer.cornerRadius = self.animalPicture.frame.size.height/20
//        self.animalPicture.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AnimalTableViewCell
    
        

        return cell
    }



}
