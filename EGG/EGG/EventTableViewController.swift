//
//  EventTableViewController.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import UIKit


class EventTableViewController: UITableViewController {
    
    var events = [Event]()
    
    func logout(){
        
        let ref = Firebase(url: "\(BASE_URL)")
        
        ref.unauth()
        
        performSegueWithIdentifier("backToLogin", sender: self)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //right bar item
        var logout = UIBarButtonItem(
            title: "Log out",
            style: .Plain,
            target: self,
            action: "logout"
        )
        
        self.navigationItem.rightBarButtonItem = logout
    
        DataService.dataService.EVENT_REF.observeEventType(.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            print(snapshot.value)
            
            self.events = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our jokes array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let event = Event(key: key, dictionary: postDictionary)
                        
                        // Items are returned chronologically, but it's more fun with the newest jokes first.
                        
                        self.events.insert(event, atIndex: 0)
                    }
                }
                
            }
            
            // Be sure that the tableView updates when there is new data.
            
            self.tableView.reloadData()
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let event = events[indexPath.row]
        
        // We are using a custom cell.
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as? EventTableViewCell {
            
            // Send the single event to configureCell() in EventTableViewCell.
            
            cell.configureCell(event)
            
            return cell
            
        } else {
            
            return EventTableViewCell()
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "eventDetail") {
            //var event: Event!
            
            // Get the cell index for current cell
            var selectedItems: [AnyObject] = self.tableView.indexPathsForSelectedRows!
            let selectedItem: NSIndexPath = selectedItems[0] as! NSIndexPath
            let selectedIndex: Int = selectedItem.row
            
            let selectedEvent = events[selectedIndex]
            
            // Get event name and detail URL for current cell
            let eventName: String = selectedEvent.eventName
            let eventDetail: String = selectedEvent.eventDetail
            
            // Set destination view controller
            let detailView: EventDetailViewController = segue.destinationViewController as! EventDetailViewController
            
            // Pass data from current view controller to detail view controller
            detailView.nameString = eventName
            detailView.detailString = eventDetail

            
        }
    }

    
}



