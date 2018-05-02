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

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    var dbref : DatabaseReference!
    var geoFire : GeoFire!
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        dbref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: dbref)
        mapView.delegate = self //make the view controller the map view 's delegate (why does it do this?)
        mapView.userTrackingMode = MKUserTrackingMode.follow //have map centered on user's location

    }

    //USING GEOFIRE TO GET THINGS NEARBY
    //request for pokemon(keys) within a region and create an annotation for the pokemon returned
    func showSightingsOnMap(location: CLLocation){

        //returns an array ?
        let circleQuery = geoFire.query(at: location, withRadius: 2.5) //query for locations 2.5 km away from user

        //listen and handle returned data(keys), aka PokemonId
        //IS EVERY ANNOTATION ADDED? WHAT HAPPENES?
        _ = circleQuery.observe(GFEventType.keyEntered, with: { (placeName, location) in

            let placeName = placeName
            let location = location


//            let anno = TaskAnnotation(coordinate: location.coordinate, numOfTasks: , placeName: key as! String)
//            self.mapView.addAnnotation(anno) //display annotations on map
            ////WHAT DOES ADDANNOTATION DO?

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //go to PlacesListController
    @IBAction func viewMyPlaces(_ sender: Any) {
        performSegue(withIdentifier: "goToPlaces", sender: locationManager.location!)
    }


    @IBAction func centerMapOnUser(_ sender: Any) {
//        if let location = locationManager.location {
//            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//            region.center = mapView.userLocation.coordinate
//            mapView.setRegion(region, animated: true)
//        }
//        else {
//            print("GIVE ME A VALID LOCATION")
//        }
    }
    
    
    


    

      // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let action = segue.identifier {
                
                //if SELECT member
                if action == "goToPlaces", let vc = segue.destination as? PlacesListController, let loc  = sender as? CLLocation{
                    vc.currentLocation = loc
                }
                
                else{
                    print("not a valid action or location")
                    
                }
            }


        }
}




