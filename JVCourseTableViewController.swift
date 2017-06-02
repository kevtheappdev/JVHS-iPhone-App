//
//  JVCourseTableViewController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/7/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVCourseTableViewController: UITableViewController {
    var course:NSDictionary!
    var selectedAssignment:NSDictionary?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
        self.selectedAssignment = ((self.course["assignments"] as! NSArray)[(indexPath as NSIndexPath).row] as! NSDictionary)
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "detail", sender: self)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 147
        }
        
        return 106
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
         return ((course["assignments"] as? NSArray)?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath as NSIndexPath).section == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! JVCourseHeaderCell
            
             cell.setCourse(self.course)
             cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "jv") as! JVAssignmentCell
            print(cell.contentView.subviews.count)
            cell.setAssignment(((self.course["assignments"] as! NSArray)[(indexPath as NSIndexPath).row] as! NSDictionary))
            
            return cell
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextVC = segue.destination as! JVGradeDetailController
        nextVC.assignment = self.selectedAssignment
    }
    
}
