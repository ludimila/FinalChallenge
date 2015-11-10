//
//  AnimalVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 27/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalBreed: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = ["Nome: ", "Raça: ","Vacinado: ", "Tipo: ", "Status: ", "Descrição:"]
    var arrayCell = Array<AnimalTableViewCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animalPicture.layer.borderWidth = 2.0
        self.animalPicture.layer.masksToBounds = true
        self.animalPicture.layer.borderColor = UIColor.brownColor().CGColor
        self.animalPicture.layer.cornerRadius = 60
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AnimalTableViewCell
        
        cell.dataLabel.text = data[indexPath.row]
        
        arrayCell.append(cell)
        
        cell.dataTextField.tag = indexPath.row
        
        print(cell.dataTextField.tag)
        
        return cell
    }
    
    @IBAction func saveData(sender: AnyObject) {
        
        let animal = Animal()
        
        for i in self.arrayCell {
            
            switch(i.dataTextField.tag){
                
            case 0 :
                animal.animalName = i.dataTextField.text!
            case 1 :
                animal.breed = i.dataTextField.text!
            case 2:
                animal.vaccinated = true
            case 3:
                
                let type = TypeAnimal()
                type.typeDescription = i.dataTextField.text!
                animal.animalType = type
                
            case 4:
                let status = StatusAnimal()
                status.situation = i.dataTextField.text!
                animal.animalStatus = status
                
            case 5:
                animal.animalDescription = i.dataTextField.text!
                
            default:
                print("nada")
                
            }
            
        }
        
        
        print("Nome -> \(animal.animalName!)")
        print("Breed -> \(animal.breed!)")
        print("Vaccinated -> \(animal.vaccinated!)")
        print("Status -> \(animal.animalStatus!)")
        
        
        
        
        
        
        
        
        if ( animal.animalName != "" && animal.breed != "" && animal.vaccinated != nil && animal.animalStatus?.situation != "" && animal.animalDescription != ""){
            
            
            print("Animal nao ta vazio")
            
            AnimalDAO.signUpAnimal(animal) { (sucessed,error) -> Void in
                if sucessed {
                    
                    print("E NOIZ")
                    
                }else {
                    
                    print("Deu ruim fi")
                    
                    
                }
                
            }
            print(animal)
        }else {
            
            let alert = UIAlertView(title: "Alerta", message: "Há algum campo vazio, verifique!", delegate: self, cancelButtonTitle: "Sair")
            
            alert.show()
            
        }
    }
    
    
}
