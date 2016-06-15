//
//  EventDetailViewController.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var detailWebView: UIWebView!
    
    var nameString: String?
    var detailString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set detail controller title
        self.title = nameString
        
        // Load detail web view
        let requestURL = URL(string: detailString!)
        let request = URLRequest(url: requestURL!)
        detailWebView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
