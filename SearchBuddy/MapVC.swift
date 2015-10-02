//
//  MapVC.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 01/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    @IBOutlet weak var map: MKMapView!
    
    
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
        
    // --------------------------------------------------
        

        
        
        
        // Configurações iniciais do mapa
        map.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    
        // Verifica se autorização dada pela usuário para captar localização
        let auth = CLLocationManager.authorizationStatus()
        
        if( auth == CLAuthorizationStatus.NotDetermined){
          print("Autorização indeterminada")
        }
 
        // Localização do usuário no mapa
        map.showsUserLocation = true;
        
        // Pede autorização pro usuário para obter sua localização
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var pontoMapa = CLLocationCoordinate2D()
        
        
        pontoMapa.latitude = 0;
        pontoMapa.longitude = 0;
        
        let myAnn = Annotation(coordinate: pontoMapa, title: "teste", subtitle: "testando")
        
        
        map.addAnnotation(myAnn)
        
        
        print("\(map.annotations.count)")
        
    }
    
    
    // Método para adicionar Pins no mapa
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinAnn = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        if ( pinAnn.isMemberOfClass(MKUserLocation)){
            print("Deu ruim")
        }
        
        pinAnn.pinTintColor = MKPinAnnotationView.redPinColor()
        pinAnn.animatesDrop = true
        
        return pinAnn
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
