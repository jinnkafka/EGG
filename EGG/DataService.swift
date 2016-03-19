//
//  DataService.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

class DataService {
    
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _EVENT_REF = Firebase(url: "\(BASE_URL)/Event")
    private var _SPONSOR_REF = Firebase(url: "\(BASE_URL)/Sponsor")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var EVENT_REF: Firebase {
        return _EVENT_REF
    }
    
    var SPONSOR_REF: Firebase {
        return _SPONSOR_REF
    }
    

}
