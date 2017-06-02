//
//  CourseInterfaceController.swift
//  JVHS
//
//  Created by Kevin Turner on 4/29/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import WatchKit
import Foundation

class CourseInterfaceController: WKInterfaceController {

    @IBOutlet var assignmentTable: WKInterfaceTable!
    override func awake(withContext context: AnyObject?) {
        print("new context")
        let course = context as! [String : AnyObject]
        print("new courses: \(course)")
        let currentCourse = course["course"] as! [String : AnyObject]
        let assignments = currentCourse["assignments"] as! [AnyObject]
        print("assignments: \(assignments)")
        if assignments.count > 0 {
            assignmentTable.setNumberOfRows(assignments.count, withRowType: "assignments")
            for (index, assign) in assignments.enumerated() {
                let row = assignmentTable.rowController(at: index) as! AssignmentTableRowController
                let score = assign["score"] as! Double
                let name = assign["name"] as! String
                print("name of assignment: \(name)")
                row.rowGroup.setBackgroundColor(JVUtility.findColor(score))
                row.assignLabel.setText(name)
                row.gradeLabel.setText(String(format: "%.2f", score))
            }

        } else {
            assignmentTable.setNumberOfRows(1, withRowType: "assignments")
           let row =  assignmentTable.rowController(at: 0) as! AssignmentTableRowController
            row.assignLabel.setText("No Assignments")
        }
        
        
           }
    
}
