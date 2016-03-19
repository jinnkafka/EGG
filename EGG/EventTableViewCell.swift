//
//  EventTableViewCell.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import UIKit


class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    var event: Event!
    
    func configureCell(event: Event) {
        self.event = event
        
        // Set the labels and textView.
        
        self.nameLabel.text = event.eventName
        print(event.eventName)
        self.timeLabel.text = event.eventTime
        print(event.eventTime)
        self.addressLabel.text = event.eventAddress
        
    }
    
    
    
}
