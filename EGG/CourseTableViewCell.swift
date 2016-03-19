//
//  CourseTableViewCell.swift
//  EGG
//
//  Created by Yuan Fu on 3/19/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import Foundation
import UIKit


class CourseTableViewCell: UITableViewCell {

    
    @IBOutlet weak var schoolImage: UIImageView!
    
    var schoolName: String?
    
    func configureCell(relatedImage: UIImage, schoolName: String) {
        
        schoolImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        schoolImage.image = relatedImage
        
        self.schoolName = schoolName
        
        print(self.schoolName);
        
    }
    
    

    
    
}

