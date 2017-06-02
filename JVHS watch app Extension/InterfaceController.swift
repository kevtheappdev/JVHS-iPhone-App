//
//  InterfaceController.swift
//  JVHS watch app Extension
//
//  Created by Kevin Turner on 4/21/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController, JVRequestDelegate, WCSessionDelegate {

    @IBOutlet var classTable: WKInterfaceTable!
    var grades: NSArray!
    
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        
        let delegate =  WKExtension.shared().delegate as! ExtensionDelegate
        delegate.requestUserLogin()
        
        classTable.setNumberOfRows(1, withRowType: "LoadingRow")
        let row = classTable.rowController(at: 0) as! LoadingCell
       row.loadingLabel.setText("Loading....")
        
        
        NotificationCenter.default().addObserver(self, selector: #selector(InterfaceController.replyReceived(_:)), name: "userInfo", object: nil)
        
        
    }
    
    
    
    
    func replyReceived(_ reply: Notification){
        
        let userInfo = (reply as NSNotification).userInfo!
        if userInfo.first == nil {
           
            let titleOfAlert = "Error "
            let messageOfAlert = "Make sure you've set things up on the phone and your phone is connected"
            self.presentAlert(withTitle: titleOfAlert, message: messageOfAlert, preferredStyle: .alert, actions: [WKAlertAction(title: "OK", style: .default){
                //something after clicking OK
                
                }])
        } else {
        let username = userInfo["username"] as! String
        let password = userInfo["password"] as! String
        let requester = JVRequester()
        
        requester.delegate = self
        
        let user = User(username: username, password: password, s_id: "", notifications: false)
        requester.getGrades(user)
        }
    }
    
    
    
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType) {
       print("request has been done")
        classTable.setNumberOfRows(7, withRowType: "ClassTableRow")
        do {
            print(NSString.init(data: data, encoding: 0))
            let dic = (try JSONSerialization.jsonObject(with: (NSString(data: data, encoding: String.Encoding.ascii.rawValue)?.data(using: String.Encoding.utf8.rawValue))!, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? NSDictionary ?? [String:String]()
            
            let grades = dic["results:"] as! NSArray
            self.grades = grades
            print(grades)
            var lowest = ["Course" : 200.0]
            for (index, course) in grades.enumerated() {
                print("row \(index)")
                
                let courseName = course["courseName"] as! String
                let average = course["average"] as! Double
                
                if let currentLowest = lowest.first {
                     let lowestAverage = currentLowest.1
                    if average < lowestAverage &&  average > 0.0 {
                        lowest = [courseName : average]
                    }
                }
                
                let row = classTable.rowController(at: index) as? ClassTableRowController
                
                row!.classLabel.setText(String(format: "\(courseName) - %.2f", average))
                row!.averageLabel.setText(String(format: "%.2f", average))
                 print("course name : \(courseName)")
                
                row!.rowGroup.setBackgroundColor(JVUtility.findColor(average))
            }
            
            NotificationCenter.default().post(name: Notification.Name(rawValue: "complicationData"), object: self, userInfo: lowest)
            
        } catch   {
            let titleOfAlert = "Network Error"
            let messageOfAlert = "Check your internet and try again"
            self.presentAlert(withTitle: titleOfAlert, message: messageOfAlert, preferredStyle: .alert, actions: [WKAlertAction(title: "OK", style: .default){
                //something after clicking OK
                }])
           
            print("we had a problem \(error)")
        }
    }
    
    
    
    
    

    
   
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if grades != nil {
        let course = self.grades[rowIndex]
        return ["course" : course]
        }
        
        return [:]
    }
   
    
    func requestFailed() {
        let titleOfAlert = "Error "
        let messageOfAlert = "Make sure you've set things up on the phone and your phone is connected"
        self.presentAlert(withTitle: titleOfAlert, message: messageOfAlert, preferredStyle: .alert, actions: [WKAlertAction(title: "OK", style: .default){
            //something after clicking OK
            
            }])

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    
        super.willActivate()
    }
    
    

    
    override func didAppear() {
        super.didAppear()
        if self.grades == nil {
            
            let delegate =  WKExtension.shared().delegate as! ExtensionDelegate
            delegate.requestUserLogin()
        }
    }
    
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
