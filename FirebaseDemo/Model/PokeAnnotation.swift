//
//  PokeAnnotation.swift
//  FirebaseDemo
//
//  Created by Derek Lin on 4/28/18.
//  Copyright © 2018 umii. All rights reserved.
//

import Foundation
import MapKit

class PokeAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var pokemonNumber : Int
    var pokemonName : String
    var title : String?
    
    var pokemon = ["dsjfksda", "asdfsaf"]
    
    init(coordinate: CLLocationCoordinate2D, pokemonNumber: Int){
        self.coordinate = coordinate
        self.pokemonNumber  = pokemonNumber
        self.pokemonName = pokemon[1].capitalized
        
        //annotation property
        self.title = self.pokemonName
    }
}
