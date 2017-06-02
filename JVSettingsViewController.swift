//
//  JVSettingsViewController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/14/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVSettingsViewController: UITableViewController, JVRequestDelegate {
     let persistence = JVPersistenceStoreManager()
    var loggedOn: Bool!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        self.loggedOn = persistence.isLoggedOn() != nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CREDITS"
        } else {
            return "ACCOUNT"
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 2
        }
        else
        {
           return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = UIColor.purple
        cell.textLabel?.textAlignment = NSTextAlignment.center
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
            cell.textLabel?.text = "A Kevin Turner Production™"
            } else {
                cell.textLabel?.text = "App icon by Daniel Davis"
            }
        } else {
            print(loggedOn)
            if loggedOn! {
                cell.textLabel?.text = "Log Out"
                print("currently logged on")
            } else {
                cell.textLabel?.text = "Login"
                print("not currently logged on")
            }
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 1 {
            if loggedOn! {
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {(action) in
                    if self.persistence.logOut() {
                          let loggedOut = UIAlertController(title: "Logged Out", message: "You have been logged out", preferredStyle: UIAlertControllerStyle.alert)
                          let okbutton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        loggedOut.addAction(okbutton)
                        self.loggedOn = false
                        self.present(loggedOut, animated: true, completion: nil)
                        self.tableView.reloadData()

                    } else {
                        let failed = UIAlertController(title: "Failed to logout", message: "We could not log you out for some reason, please try again", preferredStyle: UIAlertControllerStyle.alert)
                        let done = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        failed.addAction(done)
                        self.present(failed, animated: true, completion: nil)
                    }
                })
                
                alert.addAction(ok)
                
                let no = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(no)
                
                self.present(alert, animated: true, completion: nil)
            }  else {
                print("otherwise")
                LoginManager.presentLogin(self)
            }
        }
    }
    
    
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType) {
        print(NSString(data: data, encoding: String.Encoding.ascii.rawValue))
        do {
        let dic = (try JSONSerialization.jsonObject(with: (NSString(data: data, encoding: String.Encoding.ascii.rawValue)?.data(using: String.Encoding.utf8.rawValue))!, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? NSDictionary ?? [String : String]()
        
        let username = dic["username"] as! String
        let password = dic["password"] as! String
        let user_id = dic["user_id"] as! String
        
        let user = User(username: username, password: password, s_id: user_id, notifications: nil)
        
        persistence.saveUser(user)
        self.loggedOn = true
        DispatchQueue.main.async(execute: {() in
          self.tableView.reloadData()
        })
        } catch {
            print("There was a problem logging in")
            let alert = UIAlertController(title: "Could'nt log on", message: "We could not log you on. Please check your username and password and try again.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action)in
               DispatchQueue.main.async(execute: {() in
                 LoginManager.presentLogin(self)
                })
            })
            alert.addAction(action)
            DispatchQueue.main.async(execute: {() in
              self.present(alert, animated: true, completion: nil)
             })
            
        }
        
    }
    
    func requestFailed() {
        
    }
    
}
