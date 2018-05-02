//
//  TaskListController.swift
//  FirebaseDemo
//
//  Created by Derek Joshua Lin on 5/1/18.
//  Copyright © 2018 umii. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class TaskListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dbref : DatabaseReference;
    var geoFire : GeoFire;
    
    var place : String = "";
    var tasks : [String] = [];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @IBOutlet var taskList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //save GPS location of pokemon in DB
    //ASSOCIATE LOCATION WITH INFORMATION
    func createTaskForPlace(forLocation location: CLLocation, withTask taskDescription: String?){
        
        //check if location exists
        //query for locations 2.5 km away from user

        if let placesQuery = geoFire?.query(at: location, withRadius: 2.5) {
            //CHECK WHAT IS RETURNED HERE.
            _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
                
                let key = key
                let location = location
                
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(anno) //display annotations on map
                ////WHAT DOES ADDANNOTATION DO?
                
            })
        }
        
        
        //listen and handle returned data(keys), aka PokemonId
        //IS EVERY ANNOTATION ADDED? WHAT HAPPENES?
        
        
        //create a places object with location key
        if let task = taskDescription {
            geoFire.setLocation(location, forKey: task)
        }
        
    }
    
    
    
    
    @IBAction func exitToMapView(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}
