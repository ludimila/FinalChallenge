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

        map.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    
        let auth = CLLocationManager.authorizationStatus()
        
        if( auth == CLAuthorizationStatus.NotDetermined){
          print("nao sei")
        }
 
        
        map.showsUserLocation = true;
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }

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
