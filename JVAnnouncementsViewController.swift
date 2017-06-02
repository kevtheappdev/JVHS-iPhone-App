//
//  JVAnnouncementsViewController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/13/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVAnnouncementsViewController: UITableViewController, JVRequestDelegate
{
    var requester: JVRequester!
    var loadingView: JVLoadingView?
    var announcementArray: NSArray?
    var failed: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Announcements"
        requester = JVRequester()
        requester.delegate = self
        announcementArray = NSArray()
        loadingView = JVLoadingView(frame: self.view.frame, loadingMessage: "Loading Announcements...")
        loadingView?.isUserInteractionEnabled = false
        self.navigationController?.view.addSubview(loadingView!)
        
       requester.getAnnouncements()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.announcementArray!.count > 0 || (failed && section == 0){
            return 1
        } else if failed && section == 1 {
           return 0
        }
        
        return (self.announcementArray?.count)!
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !failed {
        let announce = self.announcementArray![(indexPath as NSIndexPath).row] as! NSDictionary
        
        
        if (indexPath as NSIndexPath).section == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcement") as! JVAnnouncementCell
        
        cell.setAnnouncement(announce["announcement"] as! String)
        
        return cell
        } else {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "date") as! JVAnnouncementsDateCell
            
            dateCell.setDate(announce["date"] as! String)
            
            return dateCell
         }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "announcement") as! JVAnnouncementCell
            cell.setAnnouncement("No data to show")
            print("failed table view source")
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
        if (indexPath as NSIndexPath).section == 0 || failed {
            return 64
        }
        
        let text = (self.announcementArray![(indexPath as NSIndexPath).row] as! NSDictionary)["announcement"] as! String
        
        
       let size =  JVUtility.labelHeight(text as NSString, font: UIFont.systemFont(ofSize: 17), width: self.view.frame.size.width-40)
        print(size.height)
        
        return ceil(size.height+30)
    }
    
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType) {
        DispatchQueue.main.async(execute: {() in
               self.loadingView?.removeFromSuperview()
            })
        
        let stringData = NSString(data: data, encoding: String.Encoding.ascii.rawValue)
        print("string data " + (stringData as! String))
        let finalData = stringData?.data(using: String.Encoding.utf8.rawValue)!
        let results = (try? JSONSerialization.jsonObject(with: finalData!, options: JSONSerialization.ReadingOptions(rawValue: 0)))!
          self.announcementArray = results["results:"] as? NSArray
  
        
        DispatchQueue.main.async(flags: .barrier, execute: {() in
            self.tableView.reloadData()
        })

     
    }
    
    func requestFailed()
    {
        let alert = UIAlertController(title: "Failed to get announcements", message: "Please check your internet connection and try again", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
        
        self.failed = true
        
        DispatchQueue.main.async(execute: {() in
           self.tableView.reloadData()
            print("now reloading")
            self.loadingView?.removeFromSuperview()
        })
    }
    
    
}
