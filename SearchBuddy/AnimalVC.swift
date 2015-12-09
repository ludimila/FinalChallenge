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
    
    var data = ["Nome: ", "Raça: ","Vacinado: ", "Tipo: ", "Descrição:","Raio de busca: "]
    var arrayCell = Array<AnimalTableViewCell>()
    let animal = Animal()
    var animalsDescription = Array<String>()
    var animalType = Array<TypeAnimal>()
    var animalStatus = Array<StatusAnimal>()
    
    
    @IBOutlet weak var constraintBottonTableView: NSLayoutConstraint!
    var previousConstant: CGFloat?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Perfil Animal"
        
        if ( self.ponto != nil) {
            
            print("Ponto -> \(self.ponto)")
        }
        
        TypeAnimalDAO.getTypes({ (animalsType, error) -> Void in
            for animal in animalsType!{
                self.animalsDescription.append(animal.typeDescription!)
                self.animalType.append(animal)
            }
            self.tableView.reloadData()
        })//fim get types
        
        StatusAnimalDAO.getStatus ({ (animalStatus, error) -> Void in
            for animal in animalStatus!{
                self.animalStatus.append(animal)
            }
            self.tableView.reloadData()
        })//fim getStatus
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.animalPicture.layer.borderWidth = 2.0
        self.animalPicture.layer.masksToBounds = true
        self.animalPicture.layer.borderColor = UIColor.orangeColor().CGColor
        self.animalPicture.layer.cornerRadius = 60
        self.tableView.separatorColor = UIColor.orangeColor()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.allowsSelection = false
        
    }
    
    //    MARK: SUBIR TABLEVIEW COM KEYBOARD
    func keyboardWillShow(notification : NSNotification) {
        
        let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
        
        self.previousConstant = self.constraintBottonTableView.constant
        self.constraintBottonTableView.constant = keyboardSize!.height - 34
        
        print(self.constraintBottonTableView.constant)
        print(keyboardSize)
        
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.tableView.layoutIfNeeded()
        }
        
    }
    
    func keyboardWillHide(notification : NSNotification) {
        
        if ( self.previousConstant != nil){
            self.constraintBottonTableView.constant = self.previousConstant!
            self.tableView.layoutIfNeeded()
        }
    }
    //    ----------------------------------------------------
    
    
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
        
        if indexPath.row == 3{
            
            cell.dataTextField.hidden = true
            cell.arrayTypes = self.animalsDescription
            cell.selectType()
            cell.addSubview(cell.segmentType)
        }
        
        if (cell.respondsToSelector("setPreservesSuperviewLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        return cell
    }
    
    @IBAction func saveData(sender: AnyObject) {
        
        let owner = User.currentUser()
        animal["animalOwner"] = owner
        
        self.animal.animalStatus = self.animalStatus[1]
        
        for i in self.arrayCell {
            
            switch(i.dataTextField.tag){
                
            case 0 :
                self.animal.animalName = i.dataTextField.text!
            case 1 :
                self.animal.breed = i.dataTextField.text!
            case 2:
                self.animal.vaccinated = self.returnVaccinated(i)
            case 3:
                self.animal.animalType = selectType(i)
                
            case 4:
                self.animal.animalDescription = i.dataTextField.text!
                
            default:
                print("nada")
                
            }
        }
        
        if ( self.ponto != nil ){
            
            self.animal.local = PFGeoPoint()
            self.animal.local!.longitude = self.ponto.longitude
            self.animal.local!.latitude = self.ponto.latitude
        }
        self.saveDataInParse()
    }
    
    func saveDataInParse(){
        
        self.animal.animalPicture = ParseConvertion.imageToPFFile(self.animalPicture.image!)
        
        if ( self.animal.animalName != "" && self.animal.breed != "" && self.animal.vaccinated != nil && self.animal.animalStatus?.situation != "" && self.animal.animalDescription != ""){
            
            AnimalDAO.signUpAnimal(animal) { (sucessed,error) -> Void in
                if sucessed {
                    print("sucess")
                }else {
                    print("error")
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
    
    
    //verifica se o animal esta vacinado
    func returnVaccinated(cell:AnimalTableViewCell) -> Bool{
        
        if cell.switchVaccinated.on{
            return true
        }else{
            return false
        }//fim if
    }//fim funcao
    
    
    //verifica qual o tipo de animal
    
    func selectType(cell: AnimalTableViewCell) -> TypeAnimal{
        
        if cell.segmentType.selectedSegmentIndex == 0 {
            return self.animalType[2]
        }else if cell.segmentType.selectedSegmentIndex == 1{
            return self.animalType[1]
        }else{
            return self.animalType[0]
        }
    }
    
    
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
    
    
    
    //cancelar cadastro
    
    @IBAction func cancelAdd(sender: AnyObject) {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
}//fim controller