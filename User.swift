//
//  User.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/2/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

public class User: NSObject {
    private let username: String
    private let password: String
    private let s_id: String
    private let notificationsRegistered: Bool?
    
    init(username: String, password: String, s_id: String, notifications: Bool?){
        self.username = username
        self.password = password
        self.s_id = s_id
        self.notificationsRegistered = notifications
        super.init()
    }
    
    func getUsername() ->String
    {
        return username
    }
    
    
    func getNotification() -> Bool?
    {
        return notificationsRegistered
    }
    
    func getPassword()->String
    {
        return password
    }
    
    
    func getS_id() -> String
    {
        return s_id
    }
    
}
