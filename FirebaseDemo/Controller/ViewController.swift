//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Derek Joshua Lin on 4/28/18.
//  Copyright © 2018 umii. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    //Manages Location-related operations
    let locationManager = CLLocationManager()
    
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    
    var dbref: DatabaseReference! //REFERENCE FIREBASE DATABASE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self //make the view controller the map view 's delegate (why does it do this?)
        mapView.userTrackingMode = MKUserTrackingMode.follow //have map centered on user's location
        dbref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: dbref) //ATTACH GEOFIRE OBJECT TO DB SO IT CAN COMMUNICATE TO THE DB
    }
    
    /////////////////
    ////CLLOCATIONMANAGERDELEGATE METHODS//////
    //////////////
    
    //if authorized, show user location
    //otherwise, request if the app can use user's location when app is running
    func locationAuthStatus(){
         
        //check if app is authorized to use user's location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true;
        }
        else{
            locationManager.requestWhenInUseAuthorization() //request for location
        }
    }
    
    
    ///SAVING GPS LOCATION OF POKEMON TO DATABASE.
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int){
        
        //SAVE LOCATION TO DATABASE USING THIS KEY
        geoFire.setLocation(location, forKey: "\(pokeId)")
    }
    
    
    ///HOW ARE location Manager and locationAuthStatus diff? when are they called?
    
    //called when app is opened and already authorized to use user's location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }

    //called whenever user's location changes or
    //WHEN USER MOVES OR STARTING UP THE APP
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //center the map whenever usre's location updates
        if let loc = userLocation.location {
            //center on new location
            if !mapHasCenteredOnce{
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "ash")
        }
        return annotationView
        
    }
    
    //center map on user's location
    //HELPER METHOD
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func spotRandomPokemon(_ sender: Any) {
    }
    



}

