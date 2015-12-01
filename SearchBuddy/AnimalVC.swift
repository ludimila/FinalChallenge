//
//  AnimalVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 27/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse
import MapKit

class AnimalVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var ponto: CLLocationCoordinate2D!
    var localizacao: String!
    
    
    var data = ["Nome: ", "Raça: ","Vacinado: ", "Tipo: ", "Descrição:"]
    var arrayCell = Array<AnimalTableViewCell>()
    var arrayStatus = Array<StatusAnimal>()
    let animal = Animal()
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Perfil Animal"

        if ( self.ponto != nil) {
            
            print("Ponto -> \(self.ponto)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animalPicture.layer.borderWidth = 2.0
        self.animalPicture.layer.masksToBounds = true
        self.animalPicture.layer.borderColor = UIColor.orangeColor().CGColor
        self.animalPicture.layer.cornerRadius = 60
        self.tableView.separatorColor = UIColor.orangeColor()
        
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
        
        if indexPath.row == 2 {
            cell.addSubview(cell.switchVaccinated)
            cell.dataTextField.hidden = true
        }
        
        
        
        return cell
    }
    
    @IBAction func saveData(sender: AnyObject) {
        
        let owner = UserDAO.getCurrentUser()
        animal["animalOwner"] = owner
        
        for i in self.arrayCell {
            
            switch(i.dataTextField.tag){
                
            case 0 :
                self.animal.animalName = i.dataTextField.text!
            case 1 :
                self.animal.breed = i.dataTextField.text!
            case 2:
                self.animal.vaccinated = self.returnVaccinated(i)
            case 3:
                let type = TypeAnimal()
                type.typeDescription = i.dataTextField.text!
                self.animal.animalType = type
                
            case 4:
                self.animal.animalDescription = i.dataTextField.text!
                
            default:
                print("nada")
                
            }//fim swicth
            
        }//fim for
        
        
        if ( self.ponto != nil ){
            
            self.animal.local = PFGeoPoint()
            self.animal.local!.longitude = self.ponto.longitude
            self.animal.local!.latitude = self.ponto.latitude
        }
        self.savaDataInParse()
    }
    
    func savaDataInParse(){
        
        self.animal.animalPicture = ParseConvertion.imageToPFFile(self.animalPicture.image!)
        
        if ( self.animal.animalName != "" && self.animal.breed != "" && self.animal.vaccinated != nil && self.animal.animalStatus?.situation != "" && self.animal.animalDescription != ""){
            print("Animal nao ta vazio")
            
            AnimalDAO.signUpAnimal(animal) { (sucessed,error) -> Void in
                if sucessed {
                    print("salvou")
                }else {
                    print("nao salvou")
                }
            }
        }else {
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
    
    func returnVaccinated(cell:AnimalTableViewCell)-> Bool{
        
        if cell.switchVaccinated.on{
            return true
        }else{
            return false
        }//fim if
    }//fim funcao


    
    
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showAnimalProfile"{
            if let animalProfile = segue.destinationViewController as? AnimalProfileVC{
                animalProfile.currentAnimal = self.animal
            }
            
        if (segue.identifier == "saveAnimal") {
            
                let aProfileVC = segue.destinationViewController as! AnimalProfileVC
                
                print("Local -> \(self.localizacao)")
                aProfileVC.endereco = localizacao
                
            }
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}//fim controller