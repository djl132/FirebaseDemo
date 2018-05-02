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
    var numOfTasks : Int?
    var placeName : String?
    
    var pokemon = ["dsjfksda", "asdfsaf"]
    
    init(coordinate: CLLocationCoordinate2D, numOfTasks: Int?, placeName: String?){
        self.coordinate = coordinate
        self.pokemonNumber  = pokemonNumber
        self.pokemonName = pokemon[1].capitalized
        
        //annotation property
        self.title = self.pokemonName
    }
}
