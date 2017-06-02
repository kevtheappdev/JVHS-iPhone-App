//
//  JVAnnouncementCell.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/13/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVAnnouncementCell: UITableViewCell
{
    
    
    @IBOutlet weak var announcementBody: UILabel!
    
    
    func setAnnouncement(_ announce: String){
       self.announcementBody.text = announce
    }
    
    
    
}
