//
//  JVRSSViewController.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/13/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit
import SafariServices

enum rssType {
    case typeNews
    case typeCalendar
}

class JVRSSViewController: UITableViewController, JVRequestDelegate, XMLParserDelegate
{
    var rss: NSMutableArray!
    var itemTitle: NSMutableString?
    var item: NSMutableDictionary?
    var link: NSMutableString?
    var elementName: String?
    var date: NSMutableString?
    var type: rssType!
    let requester = JVRequester()
    var loadingView: JVLoadingView?
    var failed: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        rss = NSMutableArray()
        requester.delegate = self
        
        if type == rssType.typeCalendar {
            self.navigationItem.title = "Calendar"
            loadingView = JVLoadingView(frame: self.view.frame, loadingMessage: "Loading Calendar...")
             loadingView?.isUserInteractionEnabled = false
            self.navigationController?.view.addSubview(loadingView!)
            requester.getCalendar()
            
        } else {
            self.navigationItem.title = "News"
            loadingView = JVLoadingView(frame: self.view.frame, loadingMessage: "Loading News")
            loadingView?.isUserInteractionEnabled = false
            self.navigationController?.view.addSubview(loadingView!)
            requester.getNews()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if failed {
            return 1
        } else {
        return rss.count
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadingView?.removeFromSuperview()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rss") as! JVRSSCell
        
        if failed {
            cell.setRSS("", date: "No data to show")
            cell.isUserInteractionEnabled = false
        } else {
        
         let rssItem = self.rss[(indexPath as NSIndexPath).row] as! NSDictionary
         let date = rssItem["date"] as! String
         let title = rssItem["title"] as! String
         print(date)
        cell.setRSS(title, date: date)
        }
        
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !failed {
        let rssItem = self.rss[(indexPath as NSIndexPath).row] as! NSDictionary
        let title = rssItem["title"] as! String
        
    
        
        let font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        
        let size = JVUtility.labelHeight(title as NSString, font: font, width: self.view.frame.size.width-2)
        print(size.height)
        return ceil(size.height + 50);
        } else {
            return 50
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
          let rssItem = self.rss[(indexPath as NSIndexPath).row] as! NSDictionary
          let link = rssItem["link"] as! String
           let url = URL(string: link.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        let browser = SFSafariViewController(url: url!)
        self.present(browser, animated: true, completion: nil)
    }
    
    
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType)
    {
        let stringData = NSString(data: data, encoding: String.Encoding.ascii.rawValue)
        print("string data " + (stringData as! String))
        let finalData = (stringData?.data(using: String.Encoding.utf8.rawValue))!
        
        let parser = XMLParser(data: finalData)
        
        parser.delegate = self
        parser.parse()

    }
    
    
    func requestFailed()
    {
        var failedString = "We could not load "
        switch(type!){
        case rssType.typeCalendar:
            failedString = failedString + " calendar at this time. "
            break;
        case rssType.typeNews:
            failedString = failedString + " news at this time. "
            break;
        }
        
        failedString = failedString + " Please check your network connection  and try again."
        
       let failedAlert = UIAlertController(title: "Failed to load data", message: failedString, preferredStyle: UIAlertControllerStyle.alert)
        
        let failedOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        failedAlert.addAction(failedOk)
        
        self.present(failedAlert, animated: true, completion: nil)
        
        self.failed = true
        print("the request failed")
       DispatchQueue.main.async(execute: {() in
            self.tableView.reloadData()
        self.loadingView?.removeFromSuperview()
        })
    }
    

    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        self.elementName = elementName
        if elementName == "item" {
            self.itemTitle = NSMutableString()
            self.item = NSMutableDictionary()
            self.link = NSMutableString()
            self.date = NSMutableString()
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "item" {
            self.item?.setObject(self.itemTitle!, forKey: "title" as NSCopying)
            self.item?.setObject(self.link!, forKey: "link" as NSCopying)
            print("self.link: ")
            print(self.link)
            self.item?.setObject(self.date!, forKey: "date" as NSCopying)
               self.rss.add(self.item!)
        }
        
      
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if  let name = elementName {
            if name == "title" {
                self.itemTitle?.append(string)
            } else if name == "link" {
                self.link?.append(string)
            } else if name == "pubDate" {
                self.date?.append(string)
            }
           
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser)
    {
        DispatchQueue.main.async(execute: {() in
         self.tableView.reloadData()
            if let loadingView = self.loadingView {
                loadingView.removeFromSuperview()
            }
        })
       
    }
    
    

}
