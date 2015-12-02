//
//  Annotation.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 01/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


let kGeotificationLatitudeKey = "latitude"
let kGeotificationLongitudeKey = "longitude"
let kGeotificationRadiusKey = "radius"
let kGeotificationIdentifierKey = "identifier"
let kGeotificationNoteKey = "note"
let kGeotificationEventTypeKey = "eventType"

enum EventType: Int {
    case OnEntry = 0
    case OnExit
}


class Annotation: NSObject,MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var radius: CLLocationDirection
    var eventType: EventType?
    
    var subtitle: String? {
        let eventTypeString = eventType == .OnEntry ? "Ao entrar":"Ao sair"
        return "Raio: \(radius)m - \(eventTypeString)"
    }
    
    
    init(coordinate: CLLocationCoordinate2D,radius: CLLocationDistance ,title: String, eventType: EventType) {
        self.radius = radius
        self.coordinate = coordinate
        self.title = title
        self.eventType = eventType
    }
    
    
}
