//
//  JVAssignmentCell.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/7/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVAssignmentCell: UITableViewCell {

    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var gradeType: UILabel!

    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    func setAssignment(_ assignment: NSDictionary){
        let name = assignment["name"] as! String
        let score = assignment["score"] as! Double
        let type = assignment["type"] as! String
        
        self.assignmentName.text = name
        self.gradeLabel.text = String(format: "%.2f", score)
        self.gradeType.text = type
        self.colorView.backgroundColor = JVUtility.findColor(score)
        
    }
}
