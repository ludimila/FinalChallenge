//
//  MapVC.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 01/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var Location: UILabel!
    var pontoMapa: CLLocationCoordinate2D!
    var geocoder: CLGeocoder!
    var locationManager : CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
    var searchActive: Bool = false
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --------------------------------------------------
        
        let user = User()
        user.username = "Lucas Veras"
        user.password = "MinhaSenha"
        user.userPhoneNumber = "(61) 9295-0471"
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
            } else {
                print("CADASTROU O USUARIO")
                
                let status = StatusAnimal()
                status.situation = "Perdido"
                try! status.save()
                
                let tipo = TypeAnimal()
                tipo.typeDescription = "Cachorro"
                try! tipo.save()
                
                let animal = Animal()
                animal.animalName = "Dudu"
                animal.breed = "Vira-lata"
                animal.vaccinated = NSNumber(bool: true)
                animal.animalDescription = "Corre mais que Usain Bolt"
                animal.animalType = tipo
                animal.animalStatus = status
                animal.animalOwner = user
                try! animal.save()
                
            }
        }
        // Inicializa o geocoder
        geocoder = CLGeocoder()
        
        // Configurações iniciais do mapa
        map.delegate = self
        
        locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            
        }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Personalizar searchBar
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.BlackOpaque
        searchBar.barTintColor = UIColor.brownColor()
        searchBar.placeholder = "Animal";
        
        userLocation = locationManager.location?.coordinate
        
        
        self.map.showsUserLocation = true;
        
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
         searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
   
    /*
    func filterContentForSearchText:
    */
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
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
        
        pontoMapa = CLLocationCoordinate2D()
        
        pontoMapa.latitude = -15.864000;
        pontoMapa.longitude = -48.028995;
        
        var location : CLLocation = CLLocation(latitude: pontoMapa.latitude, longitude: pontoMapa.longitude)
        if var locationTeste : CLLocation = location {
            addRadiusCircle(locationTeste)
        }

        
        // Pinos
        let myAnn = Annotation(coordinate: pontoMapa, title: "teste", subtitle: "testando")
        myAnn.title = "Cachorro bla"
        myAnn.subtitle = "Cachorro louco"
        map.addAnnotation(myAnn)
        
    }
    
    // Método para adicionar Pins no mapa
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        
        print("\(userLocation)")
        let locUser: CLLocationCoordinate2D = userLocation
        
        if locUser.latitude == annotation.coordinate.latitude && locUser.longitude == annotation.coordinate.longitude {
            
            return nil
            
        }else {
            
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
            
            if anView == nil {
                
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                let lbl = UILabel(frame: CGRectMake(0, 0, 100, 30)) as UILabel!
                
                lbl.backgroundColor = UIColor.blackColor()
                lbl.textColor = UIColor.whiteColor()
                lbl.font = UIFont.systemFontOfSize(10)
                lbl.text = "Last Time Seen"
                lbl.alpha = 0.5
                lbl.tag = 10
                
                
                // Pin annotation
                let pinAnn = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                
                pinAnn.draggable = true
                pinAnn.canShowCallout = true
                pinAnn.pinTintColor = MKPinAnnotationView.purplePinColor()
                pinAnn.animatesDrop = true
                pinAnn.enabled = true
                
                anView?.addSubview(pinAnn)
                anView!.addSubview(lbl)
                anView!.canShowCallout = true
                anView!.frame = lbl.frame
                
            }else {
            
                anView?.annotation = annotation
                
            }
            
            
            /*
            
            let pinAnn = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            if annotation is Annotation {
            if ( pinAnn.isMemberOfClass(MKUserLocation)){
            print("Deu ruim")
            }
            
            pinAnn.draggable = true
            pinAnn.canShowCallout = true
            pinAnn.pinTintColor = MKPinAnnotationView.purplePinColor()
            pinAnn.animatesDrop = true
            pinAnn.enabled = true
            
            }
            return pinAnn
            
            */
            return anView;
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAddresFromLatitude(){
        
        let currentLocation = CLLocation(latitude: pontoMapa.latitude, longitude: pontoMapa.longitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
        
            if error != nil {
               print("Reverse geocoder deu ruim com esse erro \(error?.localizedDescription)")
               return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.Location.text = "\(pm.name!)"
            }
        
        })
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