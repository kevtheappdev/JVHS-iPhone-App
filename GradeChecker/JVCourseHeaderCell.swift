//
//  JVCourseHeaderCell.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/7/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVCourseHeaderCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseGrade: UILabel!
    
    func setCourse(_ course: NSDictionary){
         let name = course["courseName"] as! String
         let grade = course["average"] as! Double
    
        self.courseName.text = name
        self.courseGrade.text = String(format: "%.2f", grade)
        self.contentView.backgroundColor = JVUtility.findColor(grade)
        
    
    }
    
    
}
