//
//  CourseTableViewController.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import UIKit

class SchoolTableViewController: UITableViewController {
    
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
        if let cell = tableView.dequeueReusableCellWithIdentifier("courseCell") as? SchoolTableViewCell {
            
            // Send the single event to configureCell() in SponsorTableViewCell.
            
            cell.configureCell(schoolImageList[indexPath.row], schoolName: schoolList[indexPath.row])
            
            
            return cell
            
        } else {
            
            return SchoolTableViewCell()
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "schoolToChat") {
//            
//            
//            // Get the cell index for current cell
//            var selectedItems: [AnyObject] = self.tableView.indexPathsForSelectedRows!
//            let selectedItem: NSIndexPath = selectedItems[0] as! NSIndexPath
//            let selectedIndex: Int = selectedItem.row
//            
//            
//            // Get event name and detail URL for current cell
//            let schoolName: String = schoolList[selectedIndex]
//            
//            // Set destination view controller
//            //var chatView: CourseChatViewController = segue.destinationViewController as! CourseChatViewController
//            let chatView = segue.destinationViewController as! SchoolChatViewController
//            
//            // Pass data from current view controller to detail view controller
//            
//            //chatView.titleString = courseTitle
//            //chatView.ref = ref
//            chatView.title = schoolName
//            
//            let email : String = (userRef.authData.providerData?["email"] as? String)!
//            
////            let delimiter = "@"
////            
////            let separatedEmail = email.componentsSeparatedByString(delimiter)
//            
////            chatView.passValue = separatedEmail[0]
//            
//            chatView.passValue = email
//            
//            chatView.ref = Firebase(url: "\(BASE_URL)/Message/" + schoolName)
//            
//            chatView.hidesBottomBarWhenPushed = true
//            
//        }
    }


    
    
}