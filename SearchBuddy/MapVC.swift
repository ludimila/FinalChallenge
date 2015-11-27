 //
 //  MapVC.swift
 //  SearchBuddy
 //
 //  Created by Gustavo Henrique on 01/10/15.
 //  Copyright © 2015 Gustavo Henrique. All rights reserved.
 //
 
 import UIKit
 import MapKit
 
 class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UISearchControllerDelegate, UITableViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet var searchDisplay: UISearchController!
    
    // Variáveis do Mapa
    var pontoMapa: CLLocationCoordinate2D!
    var geocoder: CLGeocoder!
    var locationManager : CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
    var pontoProximo: CLLocationCoordinate2D!
    var index: Int!
    
    // View
    var vW: UIView!
    
    // Variáveis dos Animais
    var animals = Array<Animal>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.index = 0
        
        // Animais do Singleton
        
        // Inicializa o geocoder
        self.geocoder = CLGeocoder()
        
        // Configurações iniciais do mapa
        self.map.delegate = self
        self.map.showsUserLocation = true;
        
        // Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Personalizar searchBar
        self.searchBar.delegate = self
        self.searchBar.barStyle = UIBarStyle.BlackOpaque
        self.searchBar.barTintColor = UIColor(netHex: 0x1E7A8D)
        self.searchBar.placeholder = "Animal";
        
        // Verifica a user location
        self.userLocation = self.locationManager.location?.coordinate
        if (self.userLocation == nil){
            self.userLocation = CLLocationCoordinate2D()
        }
        
    }
    
    // Método do SearchController
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableItem = "SimpleTableItem"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(tableItem)
        
        if (cell == nil){
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: tableItem)
        }
        
        cell?.textLabel?.text = "TESTE"
        cell?.detailTextLabel?.text = "Xablau"
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //implementar aproximação da localidade
        
        var myRegion = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        var center = CLLocationCoordinate2D()
        
        span.latitudeDelta = 0.05
        span.longitudeDelta = 0.01
        
        myRegion.span = span
        myRegion.center = center
        
        self.searchDisplay.active = false
        self.map.setRegion(myRegion, animated: true)
        
        
    }
    
    // ========================================================
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getAddresFromLatitude()
    }
    
    func addRadiusCircle(location: CLLocation){
        let circle = MKCircle(centerCoordinate: location.coordinate, radius: 150 as CLLocationDistance)
        map.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKCircle {
            
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blackColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 155, alpha: 0.1)
            circle.lineWidth = 1
            return circle
            
        } else {
            
            return nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        print(AnimalDAO.sharedInstance().animalsArray)
        
        self.animals = AnimalDAO.sharedInstance().animalsArray
        
        
        self.navigationController?.navigationBar.topItem?.title = "Mapa"
        
        self.animals = AnimalDAO.sharedInstance().animalsArray
        self.map.removeAnnotations(self.map.annotations)
        
        var lat  = -15.863500
        var long = -48.028995
        
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
            let myAnn = Annotation(coordinate: pontoMapa, title: "teste", subtitle: "testando")
            myAnn.title = index.animalName
            myAnn.subtitle = index.animalDescription
            map.addAnnotation(myAnn)
            
            let location : CLLocation = CLLocation(latitude: pontoMapa.latitude, longitude: pontoMapa.longitude)
            if let locationTeste : CLLocation = location {
                addRadiusCircle(locationTeste)
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
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for animal in self.animals {
            
            if ((view.annotation?.title)! == animal.animalName){
                
                self.vW = UIView(frame: CGRectMake(10, self.view.frame.height, 300, 300))
                //self.vW.backgroundColor = UIColor.blackColor()
                self.vW.backgroundColor = UIColor(netHex: 0x41B6CF)
                self.vW.alpha = 0.9
                
                self.vW.addSubview(makeLabel(animal.animalName!, x: self.vW.frame.width * 0.1, y: self.vW.frame.height * 0.4, size: 28))
                self.vW.addSubview(makeLabel(animal.animalDescription!, x: self.vW.frame.width * 0.1, y: self.vW.frame.height * 0.5, size: 17))
                self.vW.addSubview(makeImage("sadPuppy", x: self.vW.frame.width * 0.4, y: self.vW.frame.height * 0.1))
                
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
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
 }