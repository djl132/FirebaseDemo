//
//  TaskCell.swift
//  FirebaseDemo
//
//  Created by Derek Joshua Lin on 5/1/18.
//  Copyright © 2018 umii. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet var taskDescription: UILabel!
    
    @IBAction func markDone(sender: AnyObject) {
    }
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
