//
//  JVAnnouncementsDateCell.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/13/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVAnnouncementsDateCell: UITableViewCell
{
   
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func setDate(_ date: String){
        dateLabel.text = date
    }
}
