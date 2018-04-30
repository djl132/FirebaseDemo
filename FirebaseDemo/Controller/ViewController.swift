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


//BRIEF BACKGROUND

//An annotation object, which is an object that conforms to the MKAnnotation protocol and manages the data for the annotation.
//An annotation view, which is a view (derived from the MKAnnotationView class) used to draw the visual representation of the annotation on the map surface.

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
    
    //WHEN USER PANS MAP, UPDATE SIGHTINGS/ANNOTATIONS.
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            showSightingsOnMap(location: loc)
    }
    
    
    //USING APPLE MAPS////////what i this?
    //tapping on map
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? PokeAnnotation {
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            let regionDistance : CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            let options = [ MKLaunchOptionsMapCenterKey : NSValue (mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan : regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving ] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options) //open APPLE MAPS with destination with options
        }
    }
    
    
    
    //Returns the view associated with the specified annotation object

    //CALLED WHENEVER YOU ADD AN ANNOTATION TO THE MAP
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView? //why make this optional?
        
        let pokeAnnotationIdentifer = "Pokemon" //pokemon reusable annotation view identifier
        
        //////////////////////////////////////////
        //CREATE ANNOTATION VIEW FOR USER/POKEMON
        //////////////////////////////////////////

        //IF USER ANNOTATION IS ADDED
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "ash")
        }
        //IF POKEMON ANNOTATION IS ADDED and POKEMON ANNOTATOIN HAS BEEN ALLOCATED BY APP ALREADY
        else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: pokeAnnotationIdentifer){
            annotationView = deqAnno
            annotationView?.annotation = annotation //WHY THIS LINE?
        }
        //IF pokemon annotation view is not allocated yet
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: pokeAnnotationIdentifer)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) //add button to
            annotationView = av
        }
        
        //////////////////////////////////////////
        //CUSTOMIZE THE POKEMON ANNOTATION VIEW
        //////////////////////////////////////////        //WHY?????? ISN'T THERE GOING TO BE AN ANNOTATION VIEW EITHER WAY ?
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation {
            annotationView.canShowCallout = true //REQUIRES TITLE
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            
            //create left map button for annotation
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        return annotationView
        
    }
    
    //center map on user's location
    //HELPER METHOD
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //save GPS location of pokemon in DB
    //ASSOCIATE LOCATION WITH INFORMATION
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int){
        
        //SAVE LOCATION TO DATABASE USING THIS KEY
        
        //create a places object with location key 
//        dbref.child("places").setLocation(location, forKey: "TsingHua")

        geoFire.setLocation(location, forKey: "\(pokeId)")
        
        
        //add information
        dbref.child("34").child("tasks").childByAutoId().setValue("Do iOS Presentation");
        
     
    }
    
    
    //USING GEOFIRE TO GET THINGS NEARBY
    //request for pokemon(keys) within a region and create an annotation for the pokemon returned
    func showSightingsOnMap(location: CLLocation){
        let circleQuery = geoFire?.query(at: location, withRadius: 2.5) //query for locations 2.5 km away from user
        
        //listen and handle returned data(keys), aka PokemonId
        //IS EVERY ANNOTATION ADDED? WHAT HAPPENES?
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            let key = key
            let location = location
            
            let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
            self.mapView.addAnnotation(anno) //display annotations on map
            ////WHAT DOES ADDANNOTATION DO?
            
        })
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ADD POKEMON TO LOCATION AT THE CENTER OF THE MAP
    @IBAction func spotRandomPokemon(_ sender: Any) {
        
//        dbref.child("users/\("12345")/username").setValue("djl132")


        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude
            , longitude: mapView.centerCoordinate.longitude)
        let rand = arc4random_uniform(151) + 1
        createSighting(forLocation: loc, withPokemon: Int(rand))
    }


}

