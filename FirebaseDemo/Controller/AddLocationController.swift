//
//  AddLocationController.swift
//  FirebaseDemo
//
//  Created by Derek Joshua Lin on 5/1/18.
//  Copyright © 2018 umii. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class AddLocationController: UIViewController {

    var dbref : DatabaseReference!;
    var geoFire : GeoFire!;
    var locationToAdd:CLLocation = CLLocation();
    @IBOutlet weak var placeName: UITextField!
    
    override func viewDidLoad() {
        dbref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: dbref)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addLocation(){
        let name = placeName.text!
        geoFire.setLocation(locationToAdd, forKey: name)//add location to places with a name
        dbref.child("places").setValue(["\(name)": "no tasks yet"])
    }
    
}


