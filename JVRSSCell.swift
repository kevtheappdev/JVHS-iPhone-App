//
//  JVRSSCell.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/14/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVRSSCell: UITableViewCell
{

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    
    
    func setRSS(_ news: String, date: String){
        dateLabel.text = date
        newsLabel.text = news
        print(dateLabel.font)
    }
    
}
