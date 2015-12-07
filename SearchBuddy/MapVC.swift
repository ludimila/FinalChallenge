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
    }
    
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
    
    
    // Método do SearchController
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
        //implementar aproximação da localidade
        
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
    
    // ========================================================
    
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
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        if self.flag == true{
            self.flag = false
            
            
            
            var region = MKCoordinateRegion() as MKCoordinateRegion!
            var span = MKCoordinateSpan() as MKCoordinateSpan!
            
            span.latitudeDelta = 0.005
            span.longitudeDelta = 0.005
            var location = CLLocationCoordinate2D()
            location.latitude =  (self.animalFromFeed?.local?.latitude)!
            location.longitude = (self.animalFromFeed?.local?.longitude)!
            region.span = span
            region.center = location
            
            self.map.setRegion(region, animated: true)
            
        }
        
        self.animals = AnimalDAO.sharedInstance().animalsArray
        self.navigationController?.navigationBar.topItem?.title = "Mapa"
        self.animals = AnimalDAO.sharedInstance().animalsArray
        self.map.removeAnnotations(self.map.annotations)
        
        var lat  = -15.863866
        var long = -48.029272
        
        for index in self.animals {
            
            if ( index.local != nil) {
                pontoMapa = CLLocationCoordinate2D()
                pontoMapa.latitude = (index.local?.latitude)!
                pontoMapa.longitude = (index.local?.longitude)!
            } else {
                pontoMapa = randomPositions(lat, long: long)
                lat = lat + 1;
                long = long + 1;
            }
            
            // Pino
            let myAnn = Annotation(coordinate: pontoMapa, radius: 150, title: index.animalName!, eventType: EventType.OnEntry)
            map.addAnnotation(myAnn)
            
            let location : CLLocation = CLLocation(latitude: myAnn.coordinate.latitude, longitude: myAnn.coordinate.longitude)
            if let locationTeste : CLLocation = location {
                addRadiusOverlayForGeotification(myAnn)
                startMonitoringAnnotation(myAnn)
                
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
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        /*
        var region = MKCoordinateRegion() as MKCoordinateRegion!
        var span = MKCoordinateSpan() as MKCoordinateSpan!
        
        span.latitudeDelta = 0.005
        span.longitudeDelta = 0.005
        var location = CLLocationCoordinate2D()
        location.latitude = userLocation.coordinate.latitude
        location.longitude = userLocation.coordinate.longitude
        region.span = span
        region.center = location
        
        mapView.setRegion(region, animated: true)
       */
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for animal in self.animals {
            
            if ((view.annotation?.title)! == animal.animalName){
                
                self.animalOwner = animal.animalOwner
                
                
                self.vW = UIView(frame: CGRectMake(10, self.view.frame.height, 300, 300))
                //self.vW.backgroundColor = UIColor.blackColor()
                self.vW.backgroundColor = UIColor(netHex: 0x41B6CF)
                self.vW.alpha = 0.9
                let sizeTitle: CGFloat = 28
//                let sizeDescription: CGFloat = 17
                
                self.vW.addSubview(makeLabel(animal.animalName!, x: self.vW.frame.width/2 - sizeTitle, y: self.vW.frame.height/2-30, size: 28))
//                self.vW.addSubview(makeLabel(animal.animalDescription!, x: self.vW.frame.width/2 - sizeDescription / 2, y: self.vW.frame.height * 0.5, size: 17))
                self.vW.addSubview(makeImage("sadPuppy", x: self.vW.frame.width * 0.38, y: self.vW.frame.height * 0.1))
                
                // Botão
                
                let botao = UIButton(type: UIButtonType.Custom)
                
                
                botao.frame.size.width = 100
                botao.backgroundColor = UIColor(netHex: 0xE86905)
                botao.frame.size.height = 60
                botao.center.x = self.vW.frame.width * 0.2
                botao.center.y = self.vW.frame.height * 0.8
                botao.addSubview(makeLabel("Voltar", x: 0, y: 0 ,size: 28))
                self.vW.addSubview(botao)
                
                botao.addTarget(self, action: "dismissView", forControlEvents: UIControlEvents.TouchUpInside)
                
                let botaoPr = UIButton(type: UIButtonType.Custom)
                
                botaoPr.frame.size.width = 100
                botaoPr.backgroundColor = UIColor(netHex: 0xE86905)
                botaoPr.frame.size.height = 60
                botaoPr.center.x = self.vW.frame.width * 0.8
                botaoPr.center.y = self.vW.frame.height * 0.8
                botaoPr.addSubview(makeLabel("Dono", x: 0, y: 0 ,size: 28))
                self.vW.addSubview(botaoPr)
                
                botaoPr.addTarget(self, action: "profileVC", forControlEvents: UIControlEvents.TouchUpInside)
                
                //let anot = view.annotation as! Annotation
                //stopMonitoringGeotification(anot)
                
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
        //        profileVC.userProfile?.fetchIfNeededInBackground()
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let lbl = UILabel(frame: CGRectMake(x, y, 200, 60)) as UILabel!
        
        lbl.textColor = UIColor.whiteColor()
        lbl.font = UIFont.systemFontOfSize(size)
        lbl.text = string
        
        return lbl
    }
    
    func makeImage(name: String, x: CGFloat, y: CGFloat )->UIImageView {
        
        let image = UIImage(named: name)
        let imageView = UIImageView(frame: CGRectMake(x, y, 80, 80))
        imageView.image = image
        
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = 40
        
        return imageView
    }
    
    // ----------------------------------------------------------------------
    // Metódos para funcionar Geofencing
    
    func regionWithAnnotation(annotation: Annotation) -> CLCircularRegion{
        
        //1
        let region = CLCircularRegion(center: annotation.coordinate, radius: annotation.radius, identifier: annotation.title!)
        
        //2
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        return region
    }
    
    func startMonitoringAnnotation(annotation: Annotation) {
        
        //1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            print("Geofencing não funciona nesse device")
            return
        }
        
        //2
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            print("Sua notificação ta salva, porem só vai funcionar caso garanta que esteja autorizado no device")
        }
        
        //3
        let region = regionWithAnnotation(annotation)
        self.locationManager.startMonitoringForRegion(region)
    }
    
    /*
    func stopMonitoringGeotification(annotation: Annotation) {
         for region in locationManager.monitoredRegions {
             if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == annotation.title {
                  locationManager.stopMonitoringForRegion(circularRegion)
                 }
             }
          }
    }
 
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        if state == CLRegionState.Unknown{
            
            print("Region Desconhecida!")
            
        }else if state == CLRegionState.Inside {
            
            print("Estou dentro da region -> \(region.identifier)")
            
        }else {
            
            print("Estou fora da region  -> \(region.identifier)")
            
        }
        
    }
    */
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let userQuery: PFQuery = PFUser.query()!
        userQuery.whereKey("objectId", equalTo: "anyqr0RIQL") // The user I am logged in with
        
        let pushQuery: PFQuery = PFInstallation.query()!
        pushQuery.whereKey("user", matchesQuery: userQuery)
        
        //print(pushQuery)
        
        do{
            try PFPush.sendPushMessageToChannel((User.currentUser()?.objectId)!, withMessage: "\(region.identifier) está próximo a você se atente.")
        }catch{
            
        }
        
        //PFPush.sendPushMessageToQueryInBackground(pushQuery, withMessage: "\(region.identifier) está próximo a você se atente." )
        
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
            
            // To dentro desse infeliz eu acho!
            print("Center \(regionR.center.latitude) \(regionR.center.longitude) span \(regionR.span.latitudeDelta) \(regionR.span.longitudeDelta) user: \(localizacao.latitude) \(localizacao.longitude)| IN!")
        }else {
            
            print("Center \(regionR.center.latitude) \(regionR.center.longitude) span \(regionR.span.latitudeDelta) \(regionR.span.longitudeDelta) user: \(localizacao.latitude) \(localizacao.longitude)| OUT!")
            
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        print("ENTROU NO PREPRARE")
    //    }
    //
    
 }