//
//  GradeCalculatorViewController.swift
//  JVHS
//
//  Created by Kevin Turner on 5/4/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class GradeCalculatorViewController: UIViewController {

    
    @IBOutlet weak var thirdAverage: UITextField!
    @IBOutlet weak var secondAverage: UITextField!
    @IBOutlet weak var firstAverage: UITextField!
    
    @IBOutlet weak var letterGradeSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        self.letterGradeSelector.addTarget(self, action: #selector(GradeCalculatorViewController.letterGradeChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
 */
    }
    
    
    @objc func letterGradeChanged(_ value: UISegmentedControl){
        
        
    }
    
}
