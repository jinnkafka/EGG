//
//  Event.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//


class Event {
    private var _eventName: String!
    private var _eventAddress: String!
    private var _eventDetail: String!
    private var _eventImage: String!
    private var _eventTime: String!
    
    var eventName: String {
        return _eventName
    }
    
    var eventAddress: String {
        return _eventAddress
    }
    
    var eventDetail: String {
        return _eventDetail
    }
    
    var eventImage: String {
        return _eventImage
    }
    
    var eventTime: String {
        return _eventTime
    }
    
    // Initialize the new Joke
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._eventName = key
        
        // Within the Event, or Name, the following properties are children

        
        if let name = dictionary["name"] as? String {
            self._eventName = name
        }
        
        if let detail = dictionary["detail"] as? String {
            self._eventDetail = detail
        }
        
        if let address = dictionary["address"] as? String {
            self._eventAddress = address
        }
        
        if let time = dictionary["time"] as? String {
            self._eventTime = time
        }
        
        if let image = dictionary["image"] as? String {
            self._eventImage = image
        }
    }
    
}

