//
//  PokeAnnotation.swift
//  FirebaseDemo
//
//  Created by Derek Lin on 4/28/18.
//  Copyright © 2018 umii. All rights reserved.
//

import Foundation
import MapKit

class TaskAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var numOfTasks : Int
    var placeName : String;
    
    init(coordinate: CLLocationCoordinate2D, numOfTasks: Int, placeName: String){
        self.coordinate = coordinate
        self.placeName = placeName
        self.numOfTasks = numOfTasks
        //annotation properties
    }
}
