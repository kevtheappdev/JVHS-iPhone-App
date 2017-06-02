//
//  JVTableViewController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/1/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit
import WatchConnectivity

class JVTableViewController: UITableViewController, JVRequestDelegate {
  let persistence = JVPersistenceStoreManager()
    let requester = JVRequester()
  
    var classes: NSArray!
    var currentCourse: NSDictionary?
    var loadingView: JVLoadingView?
    var failed: Bool = false
    var user: User?
    var lowestGrade: [String : Double] = ["Class" : 200]
    
    
  

    required init?(coder aDecoder: NSCoder) {
        
        self.classes = NSArray()
        print("Initialized")
        super.init(coder: aDecoder)
          self.requester.delegate = self;
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.currentCourse = self.classes[(indexPath as NSIndexPath).row] as? NSDictionary
        self.performSegue(withIdentifier: "assignments", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if let user = persistence.isLoggedOn() {
           print(user)
            self.user = user
            loadingView = JVLoadingView(frame: self.view.frame, loadingMessage: "Loading Grades...")
            self.navigationController?.view.addSubview(loadingView!)
            self.navigationController?.view.bringSubview(toFront: loadingView!)
            requester.getGrades(user)
        } else {
            loadingView = JVLoadingView(frame: self.view.frame, loadingMessage: "Logging in...")
            self.navigationController?.view.addSubview(loadingView!)
            self.navigationController?.view.bringSubview(toFront: loadingView!)
            LoginManager.presentLogin(self)
        }
        
       self.refreshControl?.addTarget(self, action: #selector(JVTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func refresh(_ refreshControl: UIRefreshControl){
        if let user = self.user {
            self.requester.getGrades(user)
        }
        
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.loadingView?.removeFromSuperview()
    }
    
    func requestFailed()
    {
       failed = true
        
        let alert = UIAlertController(title: "We could not fetch grades at this time", message: "Please check your network connection and try again", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.async(execute: {() in
           self.tableView.reloadData()
            self.loadingView?.removeFromSuperview()
        })
    }
    
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType) {
        print("request has been completed")
        
        
        func loginRequestComp(){
            
            
            print(self.loadingView)
            do {
            let dic = (try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? NSDictionary ?? [String:String]()

            let username = dic["username"] as! String
            let password = dic["password"] as! String
            let s_id = dic["user_id"] as! String
            
            let user = User(username: username, password: password, s_id: s_id, notifications: nil)
            
            persistence.saveUser(user)
           
                if WCSession.isSupported() {
                    let session = WCSession.default()
                    session.activate()
                    do {
                      try session.updateApplicationContext(dic as! [String : AnyObject])
                    
                    } catch {
                        print("done fucked up")
                    }
                }
            
            requester.getGrades(user)
            } catch {
                print("There was a problem logging in")
                let alert = UIAlertController(title: "Could'nt log on", message: "We could not log you on. Please check your username and password and try again.", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(handler) in
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
        
        
        func gradesRequestComp(){
            print("grade request completed")
            print(self.loadingView)
     
            do {
             
                print(NSString(data: data, encoding: String.Encoding.ascii.rawValue))
                let dic = (try JSONSerialization.jsonObject(with: (NSString(data: data, encoding: String.Encoding.ascii.rawValue)?.data(using: String.Encoding.utf8.rawValue))!, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? NSDictionary ?? [String : String]()
                self.classes = dic["results:"] as! NSArray
               
                
            } catch (let error){
                print("failed ")
                let alert = UIAlertController(title: "Houston, we had a problem...", message: "We ran into an issue and we're not sure what :/, try again in a little bit", preferredStyle: UIAlertControllerStyle.alert)
                let alertbutton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(alertbutton)
                DispatchQueue.main.async(execute: {() in
                   self.present(alert, animated: true, completion: nil)
                })
                print(error)
            }
            
            DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async(execute: {
                var lowestGrade = ["Course" : 200.0]
                for course in self.classes {
                    let courseAverage = course["average"] as! Double
                    let courseName = course["courseName"] as! String
                    let lowest = self.lowestGrade.first?.1
                    
                    if courseAverage < lowest && courseAverage != 0.0{
                        lowestGrade = [courseName : courseAverage]
                    }
                }
                
                
                NotificationCenter.default().post(name: Notification.Name(rawValue: "updateComplication"), object: self, userInfo: lowestGrade)
                
            })
          
           
        }
        
     
        switch(type){
        case JVRequester.JVRequestType.requestTypeLogin:
              loginRequestComp()
     
                break;
        case JVRequester.JVRequestType.requestTypeGrades:
            print("request of type grades")
            gradesRequestComp()
            
            break;
        default:
            break;
        }
    
        
        DispatchQueue.main.async(flags: .barrier, execute: {() in
         self.tableView.reloadData()
            self.loadingView?.removeFromSuperview()
        })
        
       
       
        
        
      
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("table view loaded")
        if failed {
            return 1
        }
        return self.classes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if failed {
          let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "error")
            cell.textLabel?.text = "No data to show"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "jv", for: indexPath) as! JVClassTableViewCell
            let course = self.classes[(indexPath as NSIndexPath).row] as! NSDictionary
        cell.setCourse(course)
            
           
            
             return cell
         }
        
       
    }

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "grades"{
      
        let nextVC = segue.destination as! JVCourseTableViewController
        nextVC.course = self.currentCourse
        }
    }
    

}
