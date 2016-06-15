//
//  CourseTableViewCell.swift
//  EGG
//
//  Created by Yuan Fu on 3/19/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import Foundation
import UIKit


class SchoolTableViewCell: UITableViewCell {

    
    @IBOutlet weak var schoolImage: UIImageView!
    
    var schoolName: String?
    
    func configureCell(_ relatedImage: UIImage, schoolName: String) {
        
        schoolImage.contentMode = UIViewContentMode.scaleAspectFit
        
        schoolImage.image = relatedImage
        
        self.schoolName = schoolName
        
    }
    
    

    
    
}

