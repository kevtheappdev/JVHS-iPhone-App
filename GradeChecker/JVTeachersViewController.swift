//
//  JVTeachersViewController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/7/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit
import SafariServices

class JVTeachersViewController: UITableViewController, JVRequestDelegate {
    var teachers: NSArray!
    var requester: JVRequester!
    var loadingView: JVLoadingView?
    var failed: Bool = false
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var map:[String: Array<NSDictionary>]!
    
 
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadingView?.removeFromSuperview()
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return alphabet
    }
    
    
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType)
    {
        DispatchQueue.main.async(execute: {() in
            self.loadingView?.removeFromSuperview()
            
        })

        
        
        print("teachers review received complete requeste")
       let stringData = NSString(data: data, encoding: String.Encoding.ascii.rawValue)
       let finalData = stringData?.data(using: String.Encoding.utf8.rawValue)!
       let results = (try? JSONSerialization.jsonObject(with: finalData!, options: JSONSerialization.ReadingOptions(rawValue: 0)))!
        self.teachers = results["results:"] as! NSArray
        
        for i in 0 ..< teachers.count {
             let teacher = (teachers[i] as! NSDictionary)["name"] as! NSString
             let c = teacher.substring(to: 1)
      
            var array = self.map[c]
            array?.append(teachers[i] as! NSDictionary)
            self.map[c] = array
        }
        
               
        DispatchQueue.main.async(flags: .barrier, execute: {() in
            self.tableView.reloadData()
        })
        
    }
    
    
    func requestFailed()
    {
       failed = true
        
        let alert = UIAlertController(title: "We could not fetch Teachers at this time", message: "Please check your network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.async(execute: {() in
           self.tableView.reloadData()
            self.loadingView?.removeFromSuperview()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let stringUrl = (self.teachers[(indexPath as NSIndexPath).row] as! NSDictionary)["pageUrl"] as! String
        let url = URL(string: stringUrl)!
        let browser = SFSafariViewController(url: url)
        self.present(browser, animated: true, completion: nil)
        
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        self.teachers = NSArray()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
         self.teachers = NSArray()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requester = JVRequester()
        self.map = Dictionary()
        requester.delegate = self
         self.navigationItem.title = "Teachers"
        loadingView = JVLoadingView(frame: self.view.frame, loadingMessage: "Loading Teachers...")
        self.navigationController?.view.addSubview(loadingView!)
        requester.getTeachers()
        
        self.tableView.sectionIndexColor = UIColor.purple
        for i in 0 ..< alphabet.count {
             self.map[alphabet[i]] = Array<NSDictionary>()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return alphabet.count
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let temp = alphabet as NSArray
        return temp.index(of: title)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if failed {
            return 1
        }
        let letter = alphabet[section]
        let array = self.map[letter]
         print("count \(array?.count)")
        return array!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacher")!
        if !failed {
            let letter = alphabet[(indexPath as NSIndexPath).section]
            let array : Array<NSDictionary> = self.map[letter]!
            let teacher = array[(indexPath as NSIndexPath).row] 
         cell.textLabel?.text = teacher["name"] as? String
        
        } else {
            cell.textLabel?.text = "No data to show."
        }
        
        
        return cell;
        
    }
    
  
    
    
    
    
}
