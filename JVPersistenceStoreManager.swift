//
//  JVPersistenceStoreManager.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/2/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//


import UIKit
import CoreData

public class JVPersistenceStoreManager: NSObject {
    let moc : NSManagedObjectContext
    
    
    public override init() {
       let appDelegate = UIApplication.shared.delegate as? AppDelegate
     moc = (appDelegate?.managedObjectContext)!
    }
    
    
    func isLoggedOn() -> User?
   {
       let request = NSFetchRequest(entityName: "User")
       let results = (try! moc.fetch(request)) as? [NSManagedObject]
    
     if(results!.count != 0){
        let fetchedUser = results![0];
        let username = fetchedUser.value(forKey: "username") as? String
        let password = fetchedUser.value(forKey: "password") as? String
        let s_id  = fetchedUser.value(forKey: "s_id") as? String
        let notifications = fetchedUser.value(forKey: "notificationRegistered") as? Bool
        let user = User(username: username!, password: password!, s_id: s_id!, notifications: notifications)
        return user
     }
    
    return nil;
    
   }
    
    
    public func logOut() -> Bool
    {
        let request = NSFetchRequest(entityName: "User")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        do {
         try self.moc.execute(batchDelete)
        } catch {
            print("failed")
            return false
        }
        
        return true
    }
    
    
    public func hasRegisteredForPushNotifications() -> Bool?
    {
        let request = NSFetchRequest(entityName: "User")
        let results = (try! moc.fetch(request)) as? [NSManagedObject]
        
        if results?.count != 0{
            print("found a user")
            let user = results![0]
            print(user)
          return   user.value(forKey: "notificationRegistered") as? Bool
    
        }
        return nil
    }
    
    
    public func deregisterNotifications()
    {
        let request = NSFetchRequest(entityName: "User")
        let results = (try! moc.fetch(request)) as? [NSManagedObject]
        
        if results?.count != 0{
            let user = results![0]
            user.setValue(false, forKey: "notificationRegistered")
        }

        
        try! moc.save()
    }
    
    
    public func registerForPushNotifications()
    {
        print("registering for push notifications")
        let request = NSFetchRequest(entityName: "User")
        let results = (try! moc.fetch(request)) as? [NSManagedObject]
               
        if results?.count != 0{
            let user = results![0]
             user.setValue(true, forKey: "notificationRegistered")
             print("found user: \(user)")
        }
        
        try! moc.save()

    }
    
    
    public func saveUser(_ user: User)
    {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: self.moc)
        
        let userObject = NSManagedObject(entity: entity!, insertInto: self.moc)
        userObject.setValue(user.getUsername(), forKey: "username")
        userObject.setValue(user.getPassword(), forKey: "password")
        userObject.setValue(user.getS_id(), forKey: "s_id")
        
        
        try! self.moc.save()
    
        
    }
    
}
