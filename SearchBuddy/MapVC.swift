 //
 //  MapVC.swift
 //  SearchBuddy
 //
 //  Created by Gustavo Henrique on 01/10/15.
 //  Copyright © 2015 Gustavo Henrique. All rights reserved.
 //
 
 import UIKit
 import MapKit
 import CoreLocation
 import Parse
 
 
 class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tV: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Variáveis do Mapa
    var pontoMapa: CLLocationCoordinate2D!
    var geocoder: CLGeocoder!
    var locationManager : CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
    var pontoProximo: CLLocationCoordinate2D!
    var index: Int!
    var animaisSearchResult = Array<Animal>()
    
    var animalFromFeed: Animal?
    var flag = false
    var animalOwner: User?
    
    // View
    var vW: UIView!
    
    // Variáveis dos Animais
    var animals = Array<Animal>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.index = 0
        
        // Inicializa o geocoder
        self.geocoder = CLGeocoder()
        
        // Configurações iniciais do mapa
        self.map.delegate = self
        self.map.showsUserLocation = true;
        
        // Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // TableView Searchbar
        self.tV.delegate = self
        
        //Personalizar searchBar
        self.searchBar.delegate = self
        self.searchBar.barStyle = UIBarStyle.BlackOpaque
        self.searchBar.barTintColor = UIColor(netHex: 0x1E7A8D)
        self.searchBar.tintColor = UIColor.whiteColor()
        
        // Verifica a user location
        self.userLocation = self.locationManager.location?.coordinate
        if (self.userLocation == nil){
            self.userLocation = CLLocationCoordinate2D()
        }
        
        
        zoom(userLocation.latitude, longitude: userLocation.longitude)
        
    }
    
    // Métodos dos delegates -> UITableViewDelegate,MKMapViewDelegate, UISearchBarDelegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.tV.hidden = false
        self.searchContent(self.searchBar.text!)
        self.tV.reloadData()
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.tV.hidden = true
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animaisSearchResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableItem = "SimpleTableItem"
        var cell = tableView.dequeueReusableCellWithIdentifier(tableItem)
        if (cell == nil){
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: tableItem)
        }
        
        let animal = self.animaisSearchResult[indexPath.row]
        cell?.textLabel?.text = animal.animalName
        cell?.detailTextLabel?.text = animal.animalDescription
        
        return cell!
    }
    
    func searchContent(searchText: String) {
        self.animaisSearchResult = Array<Animal>()
        for index in self.animals {
            if ( (index.animalName?.uppercaseString)?.rangeOfString(searchText.uppercaseString) != nil ){
                if (self.animaisSearchResult.count > 0){
                    for index2 in self.animaisSearchResult {
                        if (index.animalName != index2.animalName){
                            self.animaisSearchResult.append(index)
                        }
                    }
                }else{
                    self.animaisSearchResult.append(index)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var myRegion = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        var center = CLLocationCoordinate2D()
        let animal = self.animaisSearchResult[indexPath.row]
        
        if (animal.local != nil) {
            center.latitude = (animal.local?.latitude)!
            center.longitude = (animal.local?.longitude)!
            
            span.latitudeDelta = 0.05
            span.longitudeDelta = 0.01
            
            myRegion.span = span
            myRegion.center = center
            
            self.map.setRegion(myRegion, animated: true)
        }
        
        self.searchBar.endEditing(true)
        self.tV.hidden = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if User.currentUser() != nil{
            if User.currentUser()?.locationUser == nil{
                User.currentUser()?.locationUser = ParseConvertion.getLocationUser(manager.location!)
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
                    CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
                        if let placemark = placemarks?[0]{
                            User.currentUser()?.bairro = placemark.subLocality
                            User.currentUser()?.cidade = placemark.locality
                            User.currentUser()?.saveInBackground()
                        }
                    }
                }
            }
        }
        getAddresFromLatitude()
    }
    
    func addRadiusOverlayForGeotification(anot: Annotation) {
        
        if anot.radius != 150 {
            map?.addOverlay(MKCircle(centerCoordinate: anot.coordinate, radius: anot.radius*500))
        }
        map?.addOverlay(MKCircle(centerCoordinate: anot.coordinate, radius: anot.radius))
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.lineWidth = 1.0
            circle.strokeColor = UIColor.purpleColor()
            circle.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
            return circle
        }
        return nil
        
    }
    
    
    func zoom(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        var region = MKCoordinateRegion() as MKCoordinateRegion!
        var span = MKCoordinateSpan() as MKCoordinateSpan!
        span.latitudeDelta = 0.005
        span.longitudeDelta = 0.005
        var location = CLLocationCoordinate2D()
        location.latitude =  latitude
        location.longitude = longitude
        region.span = span
        region.center = location
        self.map.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if self.flag == true{
            self.flag = false
            zoom((self.animalFromFeed?.local?.latitude)!, longitude: (self.animalFromFeed?.local?.longitude)!)
        }
        
        self.animals = AnimalDAO.sharedInstance().animalsArray
        self.navigationController?.navigationBar.topItem?.title = "Mapa"
        self.animals = AnimalDAO.sharedInstance().animalsArray
        self.map.removeAnnotations(self.map.annotations)
        
        for index in self.animals {
            
            if ( index.local != nil) {
                pontoMapa = CLLocationCoordinate2D()
                pontoMapa.latitude = (index.local?.latitude)!
                pontoMapa.longitude = (index.local?.longitude)!
                
                var myAnn = Annotation(coordinate: CLLocationCoordinate2D(), radius: 0, title: "", eventType: EventType.OnEntry)
                
                if index.animalRadius != nil {
                    let radius = index.animalRadius as! Double
                    myAnn = Annotation(coordinate: pontoMapa, radius: radius, title: index.animalName!, eventType: EventType.OnEntry)
                }else {
                    myAnn = Annotation(coordinate: pontoMapa, radius: 150, title: index.animalName!, eventType: EventType.OnEntry)
                }
                
                map.addAnnotation(myAnn)
                
                let location : CLLocation = CLLocation(latitude: myAnn.coordinate.latitude, longitude: myAnn.coordinate.longitude)
                if let _ : CLLocation = location {
                    addRadiusOverlayForGeotification(myAnn)
                    startMonitoringAnnotation(myAnn)
                    
                }

            }
        }
        
    }
    
    // Método para adicionar Pins no mapa
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMemberOfClass(MKUserLocation){
            return nil;
            
        } else {
            let pinAnn = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            pinAnn.draggable = true
            pinAnn.canShowCallout = true
            pinAnn.animatesDrop = true
            pinAnn.enabled = true
            changePinColor(pinAnn)
            
            let button = UIButton(type: UIButtonType.Custom)
            button.backgroundColor = UIColor(netHex: 0xE86905)
            button.frame.size.width = 44
            button.frame.size.height = 44
            button.setImage(UIImage(named: "inf"), forState: .Normal)
            pinAnn.leftCalloutAccessoryView = button
            
            if self.index == 0 {
                self.index = 1
            } else if self.index == 1 {
                self.index = 2
            } else {
                self.index = 0
            }
            
            return pinAnn
        }
    }
    
    
    // Método de atualização da localização do usuário
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    }
    
    // Método para clicar em um pino (Annotation) e obter informações
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for animal in self.animals {
            
            if ((view.annotation?.title)! == animal.animalName){
                
                self.animalOwner = animal.animalOwner
                
                
                self.vW = UIView(frame: CGRectMake(10, self.view.frame.height, 300, 300))
                self.vW.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7) //UIColor(netHex: 0x41B6CF)
                self.vW.layer.borderWidth = 2.0
                self.vW.layer.borderColor = UIColor.orangeColor().CGColor
                let sizeTitle: CGFloat = 28
                self.vW.addSubview(makeLabel(animal.animalName!, x: self.vW.frame.width/2 - sizeTitle, y: self.vW.frame.height/2-30, size: 28))
                
                animal.animalPicture?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil{
                        self.vW.addSubview(self.makeImage(UIImage(data: data!)!, x: self.vW.frame.width * 0  , y: self.vW.frame.height * 0))
                    }else{
                        print(error?.description)
                    }
                })
                
                let botao = UIButton(type: UIButtonType.Custom)
                botao.frame.size.width = 100
                botao.backgroundColor = UIColor(netHex: 0xE86905)
                botao.frame.size.height = 60
                botao.center.x = self.vW.frame.width * 0.2
                botao.center.y = self.vW.frame.height * 0.8
                botao.layer.zPosition = 12
                botao.addSubview(makeLabel("Voltar", x: 0, y: 0 ,size: 28))
                self.vW.addSubview(botao)
                botao.addTarget(self, action: "dismissView", forControlEvents: UIControlEvents.TouchUpInside)
                
                let botaoPr = UIButton(type: UIButtonType.Custom)
                botaoPr.frame.size.width = 100
                botaoPr.backgroundColor = UIColor(netHex: 0xE86905)
                botaoPr.frame.size.height = 60
                botaoPr.center.x = self.vW.frame.width * 0.8
                botaoPr.center.y = self.vW.frame.height * 0.8
                botaoPr.layer.zPosition = 12
                botaoPr.addSubview(makeLabel("Dono", x: 0, y: 0 ,size: 28))
                self.vW.addSubview(botaoPr)
                botaoPr.addTarget(self, action: "profileVC", forControlEvents: UIControlEvents.TouchUpInside)
                
            }
        }
        
        self.view.addSubview(self.vW)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.vW.center.x = self.view.frame.width * 0.5
            self.vW.center.y = self.view.frame.height * 0.5
        })
    }
    
    func profileVC(){
        
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = sb.instantiateViewControllerWithIdentifier("profileVC") as! ProfileVC
        
        profileVC.userProfile = self.animalOwner
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissView(){
        self.vW.removeFromSuperview()
    }
    
    func getAddresFromLatitude(){
        
        self.geocoder = CLGeocoder()
        var local: String!
        let currentLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        if (self.geocoder.geocoding == false){
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
                
                if placemarks != nil {
                    
                    if placemarks!.count > 0 {
                        let pm = placemarks![0]
                        local = "\(pm.name!)"
                    }
                    dispatch_async(
                        dispatch_get_main_queue(), {
                            self.Location.text = local
                    })
                    
                    self.geocoder.cancelGeocode()
                    
                }
            })
        }
        locationManager.stopUpdatingLocation()
    }
    
    func randomPositions(lat : CLLocationDegrees, long: CLLocationDegrees) -> CLLocationCoordinate2D {
        var newPosition = CLLocationCoordinate2D()
        
        newPosition.latitude = lat;
        newPosition.longitude = long;
        
        return newPosition
    }
    
    func changePinColor(pin : MKPinAnnotationView) {
        
        if self.index == 0 {
            pin.pinTintColor = MKPinAnnotationView.redPinColor()
        } else if self.index == 1 {
            pin.pinTintColor = MKPinAnnotationView.greenPinColor()
        } else {
            pin.pinTintColor = MKPinAnnotationView.purplePinColor()
        }
        
    }
    
    func makeLabel(string : String, x: CGFloat, y: CGFloat, size: CGFloat)-> UILabel{
        
        let lbl = UILabel(frame: CGRectMake(x, y, 120, 60)) as UILabel!
        
        lbl.textColor = UIColor.whiteColor()
        lbl.font = UIFont(name: "GrandHotel-Regular", size: size)
        lbl.text = string
        lbl.layer.zPosition = 12
        
        return lbl
    }
    
    func makeImage(image: UIImage, x: CGFloat, y: CGFloat )->UIImageView {
        
        let image = image
        let imageView = UIImageView(frame: CGRectMake(x, y, 300, 300))
        imageView.image = image
        imageView.alpha = 0.5
        imageView.layer.zPosition = 4
        
        return imageView
    }
    
    // -------------------------- Metódos para funcionar Geofencing
    
    func regionWithAnnotation(annotation: Annotation) -> CLCircularRegion{
        let region = CLCircularRegion(center: annotation.coordinate, radius: annotation.radius, identifier: annotation.title!)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        return region
    }
    
    func startMonitoringAnnotation(annotation: Annotation) {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            print("Geofencing não funciona nesse device")
            return
        }
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            print("Sua notificação ta salva, porem só vai funcionar caso garanta que esteja autorizado no device")
        }
        let region = regionWithAnnotation(annotation)
        self.locationManager.startMonitoringForRegion(region)
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let userQuery: PFQuery = PFUser.query()!
        userQuery.whereKey("objectId", equalTo: "anyqr0RIQL") // The user I am logged in with
        
        let pushQuery: PFQuery = PFInstallation.query()!
        pushQuery.whereKey("user", matchesQuery: userQuery)
        
        do{
            try PFPush.sendPushMessageToChannel((User.currentUser()?.objectId)!, withMessage: "\(region.identifier) está próximo a você se atente.")
        }catch{
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        //print("Monitorando -> \(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        //print("Sai desse lugar -> \(region.identifier)")
    }
    
    // Método para verificar raio
    func radiusForRegion(region: MKCoordinateRegion, location: CLLocationCoordinate2D) {
        
        let regionR = MKCoordinateRegion(center: region.center , span: region.span)
        let localizacao = location
        let center = regionR.center
        var northWestCorner = CLLocationCoordinate2D()
        var southEastCorner = CLLocationCoordinate2D()
        
        northWestCorner.latitude = center.latitude - (regionR.span.latitudeDelta / 2.0)
        northWestCorner.longitude = center.longitude - (regionR.span.longitudeDelta / 2.0)
        southEastCorner.latitude = center.latitude + (regionR.span.latitudeDelta / 2.0)
        southEastCorner.longitude = center.longitude + (regionR.span.longitudeDelta / 2.0)
        
        if (localizacao.latitude >= northWestCorner.latitude && localizacao.latitude <= southEastCorner.latitude && localizacao.longitude >= northWestCorner.longitude && localizacao.longitude <= southEastCorner.longitude ) {
            print("Center \(regionR.center.latitude) \(regionR.center.longitude) span \(regionR.span.latitudeDelta) \(regionR.span.longitudeDelta) user: \(localizacao.latitude) \(localizacao.longitude)| IN!")
        }else {
            print("Center \(regionR.center.latitude) \(regionR.center.longitude) span \(regionR.span.latitudeDelta) \(regionR.span.longitudeDelta) user: \(localizacao.latitude) \(localizacao.longitude)| OUT!")
        }
        
    }
    
 }