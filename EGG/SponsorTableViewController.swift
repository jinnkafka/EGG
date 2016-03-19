//
//  SponsorTableViewController.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import UIKit


class SponsorTableViewController: UITableViewController {
    
    var sponsors = [Sponsor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        DataService.dataService.SPONSOR_REF.observeEventType(.Value, withBlock: { snapshot in
     
            // The snapshot is a current look at our jokes data.
            
            print(snapshot.value)
            
            self.sponsors = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our jokes array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let sponsor = Sponsor(key: key, dictionary: postDictionary)
                        
                        // Items are returned chronologically, but it's more fun with the newest jokes first.
                        
                        self.sponsors.insert(sponsor, atIndex: 0)
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
        return sponsors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sponsor = sponsors[indexPath.row]
        
        // We are using a custom cell.
        if let cell = tableView.dequeueReusableCellWithIdentifier("sponsorCell") as? SponsorTableViewCell {
            
            // Send the single event to configureCell() in SponsorTableViewCell.
            
            cell.configureCell(sponsor)
            
            return cell
            
        } else {
            
            return SponsorTableViewCell()
            
        }
        
    }
    
    
}