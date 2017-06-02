//
//  JVRequester.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/1/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit


public class JVRequester: NSObject {
    
    public enum JVRequestType {
        case requestTypeLogin
        case requestTypeGrades
        case requestTypeTeachers
        case requestTypeAnnouncements
        case requestTypeCalendar
        case requestTypeNews
        case requestTypeNotification
    }
    
    private var requestType : JVRequestType!
   // private let url = "http://localhost:8080" //local
    private let url = "http://www.alpine-furnace-774.appspot.com"//production
    private let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
    private let session : URLSession
    public var delegate : JVRequestDelegate?
    
    override init() {
        sessionConfig.httpAdditionalHeaders = ["Accept":"application/json"]
       
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.httpMaximumConnectionsPerHost = 1
        self.session  = URLSession(configuration: self.sessionConfig)
    }
    
    private func makeRequest(_ url: URL)
    {
        
        print(self.delegate)
        session.dataTask(with: url, completionHandler: {(data, response, error) in
            print("completion handler called")
                        if (error == nil) {
                print(data)
                self.delegate?.requestCompleted(data!, type: self.requestType)
                print("request completed")
            } else {
                print("request failed")
                self.delegate?.requestFailed()
                print(error)
            }
            
        }).resume()
    
    }
    
    public func logIn(_ username: String, password: String){
        print("executing login request")
        print("http://alpine-furnace-774.appspot.com/jvapp?type=0&username="+username+"&password="+password)
        self.requestType = JVRequestType.requestTypeLogin
        let url = URL(string: self.url + "/jvapp?type=0&username="+username+"&password="+password)!
        
        makeRequest(url);
        
    }
    
    public func getGrades(_ user: User){
        let username = user.getUsername()
        let password = user.getPassword()
       
        
        self.requestType = JVRequestType.requestTypeGrades
        let url = URL(string: self.url + "/jvapp?type=1&username="+username+"&password="+password)!
        print("http://alpine-furnace-774.appspot.com/jvapp?type=1&username="+username+"&password="+password)
        makeRequest(url)
    }
    
    
    public func registerForPushNotifications(_ user: User, deviceToken: String){
        let username = user.getUsername()
        let password = user.getPassword()
        
        

        
        self.requestType = JVRequestType.requestTypeNotification
         let url = URL(string: self.url + "/jvapp?type=8&username="+username+"&password="+password+"&device_type=ios&device_token="+deviceToken)!
        makeRequest(url)
        
    }
    
    public func getTeachers()
    {
        self.requestType = .requestTypeTeachers
        let url = URL(string: self.url + "/jvapp?type=2")!
        makeRequest(url)
    }
    
    
    public func getAnnouncements()
    {
        self.requestType = JVRequestType.requestTypeAnnouncements
        let url = URL(string: self.url + "/jvapp?type=3")!
        makeRequest(url)
    }
    
    public func getCalendar()
    {
        self.requestType = JVRequestType.requestTypeCalendar
        let url = URL(string: "http://jerseyvillage.cfisd.net/tools/blocks/pro_event_list/rss.php?ctID=All%20Categories&bID=77&ordering=ASC")!
         makeRequest(url)
    }
    
    
    public func getNews()
    {
      self.requestType = JVRequestType.requestTypeNews
        let url = URL(string: "http://www.cfisd.net/tools/blocks/page_list/rss?bID=14350&cID=141&arHandle=Main")!
        makeRequest(url)
        
    }
    
    

}
