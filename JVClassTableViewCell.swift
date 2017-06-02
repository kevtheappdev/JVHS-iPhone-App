//
//  JVClassTableViewCell.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/1/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVClassTableViewCell: UITableViewCell {

    private var course: NSDictionary!
    
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var gradeColorView: UIView!
    @IBOutlet weak var className: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)  {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCourse(_ course: NSDictionary)
    {
        self.course = course
        
        let courseName = course["courseName"] as! String
        let average = course["average"] as! Double
        
        self.className.text = courseName
        self.gradeLabel.text = String(format: "%.2f", average)
        
        self.gradeColorView.backgroundColor = JVUtility.findColor(average)
    }
    
    
    
    
    

}
