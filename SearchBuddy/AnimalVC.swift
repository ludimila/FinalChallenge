//
//  AnimalVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 27/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse

class AnimalVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = ["Nome: ", "Raça: ","Vacinado: ", "Tipo: ", "Status: ", "Descrição:"]
    var arrayCell = Array<AnimalTableViewCell>()
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Perfil Animal"
    }
    
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
                
        return cell
    }
    
    @IBAction func saveData(sender: AnyObject) {
        
        let animal = Animal()
        
        let owner = UserDAO.getCurrentUser()
        animal["animalOwner"] = owner
        
        
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
        
        if ( animal.animalName != "" && animal.breed != "" && animal.vaccinated != nil && animal.animalStatus?.situation != "" && animal.animalDescription != ""){
            print("Animal nao ta vazio")
            
            AnimalDAO.signUpAnimal(animal) { (sucessed,error) -> Void in
                if sucessed {
                    
                    print("E NOIZ")
                    
                }else {
                    
                    print("Deu ruim fi")
                    
                }
                
            }
        }else {
            //criando AlertController
            let campoVazio: UIAlertController = UIAlertController(title: "Campo vazio", message: "Há algum campo vazio", preferredStyle: UIAlertControllerStyle.Alert)
            
            let action: UIAlertAction = UIAlertAction(title: "ok", style: .Default) { action -> Void in
                
            }
            campoVazio.addAction(action)
            //Present the AlertController
            self.presentViewController(campoVazio, animated: true, completion: nil)
        }

    }
    
    
    //foto de perfil do animal
    
    @IBAction func editPicture(sender: AnyObject) {
        

        //criando AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Foto", message: "Selecione a opção", preferredStyle: .ActionSheet)
        
        //cancelar a ação
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel) { action -> Void in
        
        }
        actionSheetController.addAction(cancelAction)
        
        //chama a funcao tirar foto
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Tirar Foto", style: .Default) { action -> Void in
            self.takePicture()
        }
        actionSheetController.addAction(takePictureAction)
        
        //chama funcao escolher da biblioteca
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Escolher da biblioteca", style: .Default) { action -> Void in
            self.chooseLibrary()
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    //tirar foto
    func takePicture(){
    
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            
            imagePicker.sourceType = .Camera;
            imagePicker.delegate = self
            imagePicker.allowsEditing = true //permitir a edição
        }
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //escolher foto da biblioteca
    func chooseLibrary() {
            
            let imagePicker = UIImagePickerController()
            
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.delegate = self
                imagePicker.allowsEditing = true //permitir a edição
            }
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    
    //seleciona a foto capturada e coloca na image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.animalPicture.image = image;
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    
    
    
    
}
