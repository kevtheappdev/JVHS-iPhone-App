//
//  JVGradeDetailController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/7/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVGradeDetailController: UITableViewController {

    var assignment: NSDictionary!
    
    
    override func viewDidLoad() {
        self.navigationItem.title = assignment["name"] as? String
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail") as! JVGradeDetailCell
        
        switch((indexPath as NSIndexPath).row){
            case 0:
              let dueDate = assignment["dueDate"] as! String
              
               cell.setName("Due Date", forValue: dueDate)
             break;
        case 1:
            let assignedDate = assignment["assignedDate"] as! String
            
            cell.setName("Assigned Date", forValue: assignedDate)
            break;
        case 2:
            let type = assignment["type"] as! String
            
            cell.setName("Type", forValue: type)
            
            break;
        case 3:
            let weight = assignment["weight"] as! NSInteger
            
            cell.setName("Weight", forValue: weight.description)
            break;
        case 4:
            let score = assignment["score"] as! NSInteger
            cell.setName("Score", forValue: score.description)
            break;
        case 5:
            let totalPoints = assignment["totalPoints"] as! NSInteger
            cell.setName("Total Points", forValue: totalPoints.description)
        default:
            break;
        }
        
        return cell
    }
    
    
}
