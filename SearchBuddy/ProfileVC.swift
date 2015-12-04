//
//  ProfileVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/20/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import Parse
import MapKit
import MBProgressHUD

class ProfileVC: UIViewController,UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ShowUserInProfileView{

    @IBOutlet weak var tableviewIsEmptylb: UILabel!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userPicture: UIImageView!
    
    @IBOutlet weak var telefoneDonoLb: UILabel!
    @IBOutlet weak var localizacaoDonoLb: UILabel!
    
    @IBOutlet weak var telefoneTF: UITextField!
    @IBOutlet weak var nomeTF: UITextField!
    
    @IBOutlet weak var atualizarLocation: UIButton!
    
    @IBOutlet weak var viewPhotoEdit: UIView!
    @IBOutlet weak var buttonEditPhoto: UIButton!
    
    @IBOutlet weak var naoLogadoView: UIView!
    
    var imagePicker = UIImagePickerController()
    
    var locationManager = CLLocationManager()
    var selectedRow: Int?
    
    var userProfile: User?
    var isCurrentUserFlag: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//    Mexer nas views de edição da photo do perfil
        Utilities.round(self.viewPhotoEdit, tamanhoBorda: 0)
        self.buttonEditPhoto.alpha = 1
        self.viewPhotoEdit.alpha = 0.6
        
        if (isCurrentUserFlag == true) {
            if User.currentUser() != nil{
                if User.currentUser()?.locationUser == nil{
                    // Location Manager
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.startUpdatingLocation()
                }
            }
        }
        
        // Do any additional setup after loading the view.
        self.tableView.bounces = false
        
        self.backImage.image = UIImage(named: "arches-945495_1920.jpg")
        
        self.background.backgroundColor = UIColor(red:0.49, green:0.91, blue:1.00, alpha:0.8)
        
        self.tableView.separatorColor = UIColor.orangeColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Perfil"
        
        self.tableView.reloadData()
        
        if User.currentUser() == nil && isCurrentUserFlag == true{
            naoLogadoView.hidden = false
        }else{
            naoLogadoView.hidden = true
            
            
            if (isCurrentUserFlag == true) {
                self.userProfile = User.currentUser()
                self.addEditButton()
            }
            
            self.tableView.tableFooterView = UIView(frame: CGRectZero)
            
            if self.userProfile!.userPicture != nil{
                self.userProfile?.userPicture!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        self.userPicture.image = UIImage(data: data!)
                    }
                })
            }else{
                self.userPicture.image = UIImage(named: "FotoPerfilVazio")
            }
            
            if let nomeUsuario = self.userProfile?.name {
                self.nome.text = nomeUsuario
            }else{
                self.nome.text = "Sem nome"
            }
            
            if let telefoneUsuario = self.userProfile?.userPhoneNumber {
                self.telefoneDonoLb.text = telefoneUsuario
            }else{
                self.telefoneDonoLb.text = "Indefinido"
            }
            
            
            //        Aqui pegara a cidade a respeito do cgpoint presente no user
            if self.userProfile?.locationUser != nil {
                self.localizacaoDonoLb.text =  ((self.userProfile?.bairro!)! + ", " + (self.userProfile?.cidade!)!)
            }else{
                self.localizacaoDonoLb.text = "Indefinido"
            }
            
            
            AnimalDAO.getAnimalsFromUser(self.userProfile!, completion: { () -> Void in
                self.tableView.reloadData()
                
                if AnimalDAO.sharedInstance().allAnimalsUser.count > 0{
                    self.tableView.hidden = false
                    self.tableviewIsEmptylb.hidden = true
                }else{
                    self.tableView.hidden = true
                    self.tableviewIsEmptylb.hidden = false
                }
            })

        
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Utilities.round(self.userPicture, tamanhoBorda: 2)
        self.userPicture.layer.borderColor = UIColor.whiteColor().CGColor
    }

//    MARK: Delegate do usuario 
    
    func isCurrentUser() {
        self.isCurrentUserFlag = true
    }
    
//    ---------------------------
    
    
    func addEditButton(){
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "Editar"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("isEdittingProfile"))
        
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func isEdittingProfile(){
        let rightBarButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneEditProfile"))
        
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.telefoneDonoLb.hidden = true
        self.telefoneTF.text = self.telefoneDonoLb.text
        self.telefoneTF.hidden = false
        
        self.nome.hidden = true
        self.nomeTF.text = self.nome.text
        self.nomeTF.hidden = false
        
        self.atualizarLocation.hidden = false
        
        self.viewPhotoEdit.hidden = false
        self.buttonEditPhoto.hidden = false
    }
    
    func doneEditProfile(){
        self.addEditButton()
        
        self.hideEditable()
        
        User.currentUser()?.userPhoneNumber = self.telefoneTF.text
        User.currentUser()?.name = self.nomeTF.text
        
        UserDAO.salvarUserUpdate()
        
        self.view.resignFirstResponder()
    }
    
    func hideEditable(){
        self.telefoneTF.hidden = true
        self.telefoneDonoLb.text = self.telefoneTF.text
        self.telefoneDonoLb.hidden = false
        
        self.nomeTF.hidden = true
        self.nome.text = self.nomeTF.text
        self.nome.hidden = false
        
        
        self.atualizarLocation.hidden = true
        
        self.viewPhotoEdit.hidden = true
        self.buttonEditPhoto.hidden = true
    }
    
//    MARK: ATUALIZAR FOTO
    
    @IBAction func atualizaPhoto(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message:nil, preferredStyle: .ActionSheet)
        
        
        let deletePhotoAction = UIAlertAction(title: "Apagar Foto", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.userPicture.image = UIImage(named: "FotoPerfilVazio")
            User.currentUser()?.userPicture = nil
            
            UserDAO.salvarUserUpdate()
        })
        
        let takePhotoAction = UIAlertAction(title: "Tirar Foto", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.takePhoto()
            self.hideEditable()
        })
        
        let choosePhotoAction = UIAlertAction(title: "Escolher Foto", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.takePhotoInLibrary()
            self.hideEditable()
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(deletePhotoAction)
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(choosePhotoAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func takePhoto(){
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .Camera
        self.imagePicker.allowsEditing = true
        
        presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoInLibrary(){
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .PhotoLibrary
        self.imagePicker.allowsEditing = true
        
        presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.userPicture.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let imageData = UIImagePNGRepresentation(self.userPicture.image!){
            User.currentUser()?.userPicture = PFFile(data: imageData)
        }
        
        UserDAO.salvarUserUpdate()
    }
  
//    -------------------------------------------------------
    
    @IBAction func atualizaLocation(sender: AnyObject) {
        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hub.labelText = "Atualizando..."
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    MARK: CLLocationManager
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        if isCurrentUserFlag == true{
            self.armazenaLocationUser(manager.location!)
        }
        
    }
    
    func armazenaLocationUser(location: CLLocation) {
        User.currentUser()?.locationUser = ParseConvertion.getLocationUser(location)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                if let placemark = placemarks?[0]{
                    User.currentUser()?.bairro = placemark.subLocality
                    User.currentUser()?.cidade = placemark.locality
                    
                    User.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if success{
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.localizacaoDonoLb.text =  (User.currentUser()!.bairro! + ", " + User.currentUser()!.cidade!)
                        }
                    })
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
//    ----------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimalDAO.sharedInstance().allAnimalsUser.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let animal = AnimalDAO.sharedInstance().allAnimalsUser[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
        
        
        if (cell.respondsToSelector("setPreservesSuperviewLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        
        animal.animalPicture?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil{
                cell.img.image = UIImage(data: data!)
                Utilities.round(cell.img, tamanhoBorda: 1)
                cell.img.layer.borderColor = UIColor.orangeColor().CGColor
            }
        })
        
        cell.findedButton.tag = indexPath.row
        
        cell.label.text = animal.animalName
        
        cell.findedButton.hidden = isLost(animal)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.075
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addAnimal") {
//            var uVC = segue.destinationViewController as! UserVC
//            uVC = UserVC()
            
            let pushQuery = PFInstallation.query()
            pushQuery?.whereKey("deviceType", equalTo: "ios")
            
            PFPush.sendPushMessageToQueryInBackground(pushQuery!, withMessage: "Hello World")
            

            
        }
        
        
        if segue.identifier == "showAnimalProfile"{
            if let animalProfile = segue.destinationViewController as? AnimalProfileVC{
                let cell = sender as! UITableViewCell
                let indexPath = NSIndexPath(forRow: cell.tag, inSection: 0)
                
                animalProfile.currentAnimal = AnimalDAO.sharedInstance().allAnimalsUser[indexPath.row]

            }
        }
    }
    
    func isLost(animal: Animal)->Bool{
        var isLost = true
        if animal.animalStatus?.objectId == "06cg0yLSSl"{
            isLost = false
        }
        return isLost
    }
    
    @IBAction func isFinded(sender: AnyObject) {
        
        let animal = AnimalDAO.sharedInstance().allAnimalsUser[sender.tag]
        let queryStatus = StatusAnimal.query()
        queryStatus!.whereKey("objectId", equalTo: "m2WkU7UWDg")
        
        queryStatus?.findObjectsInBackgroundWithBlock({ (status, error) -> Void in
            if error == nil{
                let statusAnimal = status as! Array<StatusAnimal>
                animal.animalStatus = statusAnimal.first
                animal.ultimaVezVisto = nil
                animal.local = nil
                animal.saveInBackgroundWithBlock({ (success, error) -> Void in
                    self.tableView.reloadData()
                })
                self.tableView.reloadData()
            }
        })
        self.tableView.reloadData()
    }
    
    @IBAction func toLoginScreen(sender: AnyObject) {
        let tabBar = self.navigationController?.parentViewController as! UITabBarController
        tabBar.selectedIndex = 4
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
