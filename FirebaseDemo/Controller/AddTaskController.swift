//
//  AddPlaceController.swift
//  FirebaseDemo
//
//  Created by Derek Joshua Lin on 5/2/18.
//  Copyright © 2018 umii. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddTaskController: UIViewController {
    
    var place : String = ""
    
    @IBOutlet weak var taskDescription:UITextField!
    var currentLocation : CLLocation = CLLocation()
    var dbref : DatabaseReference!
    var geoFire : GeoFire!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dbref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: dbref)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTask(){
        
        if let taskText = taskDescription.text {
            dbref.child("places/\(place)/tasks").childByAutoId().setValue(taskText)
        }
    }

}

