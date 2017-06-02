//
//  JVUtility.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/7/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

open class JVUtility: NSObject {

    open static func findColor(_ average: Double) -> UIColor
    {
        if average < 0.0
        {
            return UIColor.gray
        }
        else if(average < 70.0)
        {
            return UIColor.red
        }
        else if(average >= 70.0 && average < 90.0)
        {
            return UIColor(red: 0.949, green: 0.8549, blue: 0, alpha: 1.0)
        } else {
            return
                UIColor(red: 0.0118, green: 0.749, blue: 0, alpha: 1.0)
        }
    }
    
    
    open static func labelHeight(_ text: NSString, font: UIFont, width: CGFloat) -> CGSize
    {
        return text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
        
    }

    
}
