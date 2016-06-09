//
//  Sponsor.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import Foundation


class Sponsor {
    private var _sponsorName: String!
    private var _sponsorAddress: String!
    private var _sponsorBenefit: String!
    private var _sponsorImage: String!
    
    var sponsorName: String {
        return _sponsorName
    }
    
    var sponsorAddress: String {
        return _sponsorAddress
    }
    
    var sponsorBenefit: String {
        return _sponsorBenefit
    }
    
    var sponsorImage: String {
        return _sponsorImage
    }
    
    // Initialize the new Joke
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._sponsorName = key
        
        // Within the Event, or Name, the following properties are children
        
        
        if let name = dictionary["name"] as? String {
            self._sponsorName = name
        }
        
        if let benefit = dictionary["benefit"] as? String {
            self._sponsorBenefit = benefit
        }
        
        if let address = dictionary["address"] as? String {
            self._sponsorAddress = address
        }
        
        
        if let image = dictionary["image"] as? String {
            self._sponsorImage = image
        }
    }
    
}

