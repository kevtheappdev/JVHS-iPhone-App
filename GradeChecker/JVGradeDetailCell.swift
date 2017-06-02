//
//  JVGradeDetailCell.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/7/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVGradeDetailCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    
    func setName(_ name: String, forValue value: String)
    {
        self.name.text = name;
        self.value.text = value;
    }
    
}
