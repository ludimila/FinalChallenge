//
//  BuscaLocalVC.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 26/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import MapKit
import Parse

class BuscaLocalVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mkMap: MKMapView!
    var locationManager: CLLocationManager!
    var ponto: CLLocationCoordinate2D!
    var geocoder: CLGeocoder!
    var placemarks: CLPlacemark!
    var animal: Animal!
    var local: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mkMap.delegate = self
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.geocoder = CLGeocoder()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authstate = CLLocationManager.authorizationStatus()
        
        if(authstate == CLAuthorizationStatus.NotDetermined){
            
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        locationManager.startUpdatingLocation()
        
        var myRegion = MKCoordinateRegion()
        var myCenter = CLLocationCoordinate2D()
        
        
        if (locationManager != nil){
            
            myCenter.latitude = (self.locationManager.location?.coordinate.latitude)!
            myCenter.longitude = (self.locationManager.location?.coordinate.longitude)!
            
            self.ponto = myCenter
            var span = MKCoordinateSpan()
            span.latitudeDelta = 0.05
            span.longitudeDelta = 0.01
            
            myRegion.center = myCenter
            myRegion.span = span
            
            self.mkMap.setRegion(myRegion, animated: true)
            
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        
        longPress.minimumPressDuration = 0.5
        self.mkMap.addGestureRecognizer(longPress)
        
    }
    
    
    func handleLongPress(sender: UILongPressGestureRecognizer){
        
        if ( sender.state != .Began) {
            return
        }
        
        
        let touchPoint = sender.locationInView(self.mkMap)
        self.ponto = self.mkMap.convertPoint(touchPoint, toCoordinateFromView: self.mkMap)
        
        let anot = Annotation(coordinate: self.ponto, radius: 150, title: "", eventType: EventType.OnEntry)
        
        self.mkMap.removeAnnotations(self.mkMap.annotations)
        self.mkMap.addAnnotation(anot)
        
        let alert = UIAlertController(title: "Deseja confirmar?", message: "Você tem certeza que essa é a localização do seu animal?", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Sim", style: .Default) { _ in
            
            let geoPoint = PFGeoPoint()
            geoPoint.latitude = self.ponto.latitude
            geoPoint.longitude = self.ponto.longitude
            self.animal.local = geoPoint
            self.animal.ultimaVezVisto = NSDate()
            
            let queryStatus = StatusAnimal.query()
            queryStatus!.whereKey("objectId", equalTo: "06cg0yLSSl")
            
            queryStatus?.findObjectsInBackgroundWithBlock({ (status, error) -> Void in
                if error == nil{
                    let statusAnimal = status as! Array<StatusAnimal>
                    self.animal.animalStatus = statusAnimal.first
                    self.animal.saveInBackground()

                }
            })
            
            self.dismissViewControllerAnimated(true){
//                let storyBoard = self.tabBarController
//                self.presentConclusionAlert(storyBoard!)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Default){ _ in
            
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: {})

    }
    
    func getAdress(){
        
        let currentLocation = CLLocation(latitude: self.ponto.latitude, longitude: self.ponto.longitude)
        
        if (self.geocoder.geocoding == false) {
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
                
                
                if (error == nil && placemarks!.count > 0){
                    
                    self.placemarks = placemarks?.last

                    print("Endereço -> \(self.placemarks.thoroughfare!)")
                    self.local = self.placemarks.thoroughfare!
                    
                    
                }else {
                    print("Deu ruim fi")
                }
            })
        }
        locationManager.stopUpdatingLocation()
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        var pointDrag = CLLocationCoordinate2D()
        
        pointDrag.latitude = (view.annotation?.coordinate.latitude)!
        pointDrag.longitude = (view.annotation?.coordinate.longitude)!
        
        
        self.ponto = pointDrag
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pin = self.mkMap.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        
        
        if ( pin == nil){
            
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }else {
            pin?.annotation = annotation
        }
        
        pin?.animatesDrop = true
        pin?.draggable = true
        
        return pin
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "saveLoc" ){
            
            getAdress()
            
            let animalPVC = segue.destinationViewController as! AnimalVC
            
            animalPVC.ponto = CLLocationCoordinate2D(latitude: self.ponto.latitude, longitude: self.ponto.longitude)
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func presentConclusionAlert(mainView: UIViewController){
        let alert = UIAlertController(title: "Animal perdido cadastrado", message: "Você definiu que o \(self.animal.animalName!) foi perdido", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "OK", style: .Default) { _ in
            
        }
        alert.addAction(confirmAction)
        mainView.presentViewController(alert, animated: true, completion: {})
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error -> \(error)")
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
