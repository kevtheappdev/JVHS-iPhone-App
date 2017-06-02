//
//  ViewController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 2/29/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//



import UIKit
import GoogleMobileAds
import WatchConnectivity

class ViewController: UIViewController, NotificationDelegate, JVRequestDelegate, WCSessionDelegate {

    @IBOutlet weak var Calendar: UIView!
    @IBOutlet weak var AnnouncementS: UIView!
    @IBOutlet weak var newsbutton: UIView!
    @IBOutlet weak var Settings: UIView!
    @IBOutlet weak var Teachers: UIView!
    @IBOutlet weak var gradesButton: UIView!
    @IBOutlet var navigationButtons: Array<NSLayoutConstraint>!
    let persistence = JVPersistenceStoreManager()
    var feedType: rssType?
    var user: User!
    var interstitial: GADInterstitial!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.AnnouncementS.layoutSubviews()
        var constant: CGFloat = 130.0
        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-5983943916641335/7890543803")
       
        
        let request = GADRequest()
        
        
        self.interstitial.load(request)
        
        if  UIScreen.main.bounds.size.height < 568.0
        {
            constant = ((0.7)*(constant))
            
            for i in 0 ..< navigationButtons.count {
                let constraint = navigationButtons[i]
             
                
              
                constraint.constant = constant
                
            }
            
        }
        self.view.needsUpdateConstraints()
        
        print(gradesButton.frame.size.height)
        gradesButton.layer.cornerRadius = constant/2.0
        Calendar.layer.cornerRadius = constant/2.0
        newsbutton.layer.cornerRadius = constant/2.0;
        Teachers.layer.cornerRadius = constant/2.0;
        Settings.layer.cornerRadius = constant/2.0;
        AnnouncementS.layer.cornerRadius = constant/2.0;
    
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
     
        
        let user = self.persistence.isLoggedOn()
        if user != nil {
            if self.persistence.hasRegisteredForPushNotifications() == nil {
                print("persistence is nil")
                self.user = user
                let alert = UIAlertController(title: "New Grade Notifications", message: "Would you like to be notified when teachers put in new grades?", preferredStyle: UIAlertControllerStyle.alert)
                let yes = UIAlertAction(title: "Yes!", style: UIAlertActionStyle.default, handler: {(action) in
                    
                    let delegate =  UIApplication.shared.delegate as! AppDelegate
                    delegate.delegate = self
                    delegate.registerForPushNotifications(UIApplication.shared)
                })
                let no = UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.default, handler: {(action)in
                    self.persistence.deregisterNotifications()
                })
                alert.addAction(yes)
                alert.addAction(no)
                
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    func registeredForNotifications(_ token: String) {
        let requester = JVRequester()
        requester.delegate = self
         requester.registerForPushNotifications(user, deviceToken: token)
    }
    
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType) {
        self.persistence.registerForPushNotifications()
        print("persistence store manger being called")
    }
    
    
    func requestFailed() {
        let alert = UIAlertController(title: "Failed to register for Notifications", message: "We could not register you for push notifications, please your internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func newsButtonPressed(_ sender: AnyObject) {
        self.feedType = rssType.typeNews
        performSegue(withIdentifier: "rss", sender: self)
    }
    
    
    
    @IBAction func calendarButtonPressed(_ sender: AnyObject) {
      self.feedType = rssType.typeCalendar
       performSegue(withIdentifier: "rss", sender: self)
       
    }
    
    
    
    @IBAction func gradesButtonPressed(_ sender: AnyObject) {
       let persistence = JVPersistenceStoreManager()
        
        if persistence.isLoggedOn() != nil{
          if interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
          }
        }
             self.performSegue(withIdentifier: "grades", sender: self)
          print("grades button pressed")
        }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "rss" {
            if let rss = feedType {
                let nextVC = segue.destination as! JVRSSViewController
                nextVC.type = rss
            }
            
        }
    }

}

