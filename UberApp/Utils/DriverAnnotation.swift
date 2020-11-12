//
//  DriverAnnotation.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 13/11/2020.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
}
