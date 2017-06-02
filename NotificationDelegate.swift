//
//  NotificationDelegate.swift
//  JVHS
//
//  Created by Kevin Turner on 4/10/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

@objc protocol NotificationDelegate {
   
    func registeredForNotifications(_ token: String)
     @objc optional func didntRegisterForNotifications()

}
