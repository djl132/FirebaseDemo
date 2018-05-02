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

class HomeViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {

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
        let circleQuery = geoFire.query(at: location, withRadius: 2.0) //query for locations 2.5 km away from user

        //listen and handle returned data(keys), aka PokemonId
        //IS EVERY ANNOTATION ADDED? WHAT HAPPENES?
        _ = circleQuery.observe(GFEventType.keyEntered, with: { (key, location) in

            let key = key
            let location = location


//            let anno = TaskAnnotation(coordinate: location.coordinate, numOfTasks: (need number of tasks), placeName: key as! String)
//            self.mapView.addAnnotation(anno) //display annotations on map
            ////WHAT DOES ADDANNOTATION DO?

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //go to TaskListController
//    @IBAction func addTask(_ sender: Any) {
//
//    }
//

//    @IBAction func centerMapOnUser(_ sender: Any) {
//        centerMapOnLocation(locationManager)
//    }
//

    //view tasks
    func viewTasks(){

    }


}


//extension HomeViewController {
//
//
//
//
//
//
//        override func viewDidLoad() {
//
//            super.viewDidLoad()
//        }
//
//        override func didReceiveMemoryWarning() {
//            super.didReceiveMemoryWarning()
//            // Dispose of any resources that can be recreated.
//        }
//
//
//        // MARK: - Table view data source
//
//        override func numberOfSections(in tableView: UITableView) -> Int {
//            // #warning Incomplete implementation, return the number of sections
//            return 1
//        }
//
//
//        //MARK DONE
//        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        dbref.child()
//        }
//
//        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            // FIXED BY KIRAN
//            // Previously it was families.count, and needed to be changed to families[index].members.count
//            return FamiliesViewController.families[index].members.count;
//
//        }
//
//
//        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as? TableViewMemberCell else {return UITableViewCell()}
//            cell.fName.text = FamiliesViewController.families[index].members[indexPath.row].fName;
//            cell.lName?.text = FamiliesViewController.families[index].members[indexPath.row].lName;
//            cell.gender?.text = FamiliesViewController.families[index].members[indexPath.row].gender;
//            cell.affected?.text = FamiliesViewController.families[index].members[indexPath.row].affected ? "affected" : "unaffected";
//
//            return cell
//        }
//
//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//
//            // FIXED BY KIRAN
//            // Reload the table view so that it uses the new data
//            self.tableView.reloadData()
//        }
//
//        /*
//         // Override to support conditional editing of the table view.
//         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//         // Return false if you do not want the specified item to be editable.
//         return true
//         }
//         */
//
//        /*
//         // Override to support editing the table view.
//         override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//         if editingStyle == .delete {
//         // Delete the row from the data source
//         tableView.deleteRows(at: [indexPath], with: .fade)
//         } else if editingStyle == .insert {
//         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//         }
//         }
//         */
//
//        /*
//         // Override to support rearranging the table view.
//         override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//         }
//         */
//
//        /*
//         // Override to support conditional rearranging of the table view.
//         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//         // Return false if you do not want the item to be re-orderable.
//         return true
//         }
//         */
//
//        // MARK: - Navigation
//
//        // In a storyboard-based application, you will often want to do a little preparation before navigation
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if let action = segue.identifier {
//
//
//                //if SELECT member
//                if action == "chooseLocation", let vC = segue.destination as? AddLocationViewController , let indexOfMember = sender as? Int{
//                    vC.indexOfFam = self.index;
//                    vC.indexOfMem = indexOfMember;
//                    print("identifier: \(segue.identifier!)")
//                }
//                    //if ADD member
//
//                else if action == "createLocation", let addMemberVC = segue.destination as? AddMemberViewController{
//                    addMemberVC.indexOfFamily = self.index;
//                    print("\(self.index)");
//                }
//
//            }
//
//
//        }
//}




