//
//  ExtensionDelegate.swift
//  JVHS watch app Extension
//
//  Created by Kevin Turner on 4/21/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    var session: WCSession!
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if WCSession.isSupported() {
            self.session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
    }
    
    
    func requestUserLogin(){
        
        session.sendMessage(["request" : "userData"], replyHandler: {(reply) in
            print(reply["username"])
            
            
            NotificationCenter.default().post(name: "userInfo" as NSNotification.Name, object: self, userInfo: reply)
            print("reply received")
            }, errorHandler: {(error) in
                NotificationCenter.default().post(name: "userInfo" as NSNotification.Name, object: self, userInfo: [:])
                print("we had a prob \(error)")
        })
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
          print("Received complication data on watch")
        NotificationCenter.default().post(name: Notification.Name(rawValue: "complicationData"), object: self, userInfo: userInfo)
        
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
