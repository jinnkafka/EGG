//
//  CourseTableViewController.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {
    
    let schoolList = ["Marshall", "Viterbi", "Dornsife", "Annenberg", "Cinema"]
    
    let schoolImageList: [UIImage] = [UIImage(named: "marshall")!, UIImage(named: "viterbi")!,UIImage(named: "dornsife")!,UIImage(named: "annenberg")!,UIImage(named: "cinema")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        // We are using a custom cell.
        if let cell = tableView.dequeueReusableCellWithIdentifier("courseCell") as? CourseTableViewCell {
            
            // Send the single event to configureCell() in SponsorTableViewCell.
            
            cell.configureCell(schoolImageList[indexPath.row], schoolName: schoolList[indexPath.row])
            
            
            return cell
            
        } else {
            
            return CourseTableViewCell()
            
        }
        
    }

    
    
}