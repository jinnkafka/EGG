//
//  SponsorTableViewCell.swift
//  EGG
//
//  Created by Chen Jin on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import UIKit

class SponsorTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var benefitLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sponsorImage: UIImageView!
    
    
    var sponsor: Sponsor!
    
    func configureCell(_ sponsor: Sponsor) {
        
        self.sponsor = sponsor
        
        // Set the labels and textView.
        
        self.nameLabel.text = sponsor.sponsorName
        self.benefitLabel.text = sponsor.sponsorBenefit
        self.addressLabel.text = sponsor.sponsorAddress
        
        loadImageFromUrl(sponsor.sponsorImage, view: sponsorImage)
        
    }
    
    func loadImageFromUrl(_ url: String, view: UIImageView){
        
        // Create Url from string
        let url = URL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared().dataTask(with: url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    
    
}
