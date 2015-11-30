//
//  BuscaLocalVC.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 26/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import MapKit

class BuscaLocalVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mkMap: MKMapView!
    var locationManager: CLLocationManager!
    var ponto: CLLocationCoordinate2D!
    var geocoder: CLGeocoder!
    var placemarks: CLPlacemark!

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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
