
//
//  PlacesListControllerTableViewController.swift
//  FirebaseDemo
//
//  Created by Derek Joshua Lin on 5/1/18.
//  Copyright © 2018 umii. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class PlacesListController: UITableViewController, CLLocationManagerDelegate {
    
    var places : [String] = []
    var currentLocation : CLLocation = CLLocation()
    var dbref : DatabaseReference!
    var geoFire : GeoFire!
    let locationManager = CLLocationManager()
    var handle: UInt?
    
    
    @IBAction func addPlace(){
        performSegue(withIdentifier: "addPlace", sender: currentLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dbref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: dbref)
        
        //get value
        
        //gt the children in the form of dictionary as a snapshot
        handle = dbref.child("places").observe(.value, with: { (snapshot) in
            if let keys = (snapshot.value as? [String: Any])?.keys {
                self.places = Array(keys)
            } else {
                self.places = []
            }
            
            
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = handle {
            dbref.removeObserver(withHandle: handle)
            self.handle = nil
        }
    }
    
    override func viewDidLoad() {
   
        //display places
//        let placesRef = dbref.child(byAppendingPath: "places")
//        placesRef.queryOrdered(byChild: "placeName").observe(.childAdded, with: { snapshot in
//
//            if let title = snapshot.value() as? String {
//                self.titlesArray.append(title)
//            }

        super.viewDidLoad()
 
    }
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTaskList", sender: places[indexPath.row])
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as? PlaceCell else {return UITableViewCell()}
        cell.placeName?.text = places[indexPath.row]
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddLocationController, let loc = sender as? CLLocation {
            vc.locationToAdd = loc;
            print("GOT TO ADDLOCATIONCONTROLLER")

        }
     
        // Pass the selected object to the new view controller.

    }

}

