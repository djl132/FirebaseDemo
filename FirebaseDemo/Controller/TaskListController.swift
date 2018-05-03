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

class TaskListController: UITableViewController {
    

    var handle: UInt?
    var dbref : DatabaseReference!;
    var geoFire : GeoFire!;
    
    var place : String = "";
    var tasks : [String] = [];
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //CONFIGURE
        dbref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: dbref)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 25
        
        //get the children in the form of key array of dictionary as a snapshot
        handle = dbref.child("places/\(place)/tasks").observe(.value, with: { (snapshot) in
            if let keys = (snapshot.value as? [String : String])?.values {
                self.tasks = Array(keys)
            } else {
                self.tasks = []
            }
            self.tableView.reloadData()
        })
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell else {return UITableViewCell()}
        cell.taskDescription?.text = tasks[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func addTask(){
      performSegue(withIdentifier: "goAddTask", sender: place)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddTaskController  {
            vc.place = place;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    
    
    
}


