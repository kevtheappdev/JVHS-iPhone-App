//
//  ComplicationController.swift
//  JVHS watch app Extension
//
//  Created by Kevin Turner on 4/21/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import ClockKit
import WatchConnectivity

class ComplicationController: NSObject, CLKComplicationDataSource, WCSessionDelegate {
    private var complicationData : [String : AnyObject]!
  
    
    override init() {
        super.init()
        NotificationCenter.default().addObserver(self, selector: #selector(ComplicationController.complicationDataReceived(_:)), name: "complicationData", object: nil)
    }
    
    @objc func complicationDataReceived(_ data: Notification){
        self.complicationData = (data as NSNotification).userInfo as! [String : AnyObject]
        print("complication data \(complicationData)")
        let server = CLKComplicationServer.sharedInstance()
        let allComplications = server.activeComplications
        if let complications = allComplications{
          complications.forEach {
            print("reloading complication")
            server.reloadTimeline(for: $0) }
        }
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: (Date) -> Void) {
        print("hello")
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: (Date) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        print("getting current timeline entry")
        if self.complicationData != nil {
            if  let data = complicationData.first {
            
            let lowestClass = data.1 as! Double
            let lowestClassName = data.0
            let entry = createTimelineEntry("Lowest Class", bodyText: String(format: "\(lowestClassName) %.2f", lowestClass), date: Date())
           
            handler(entry)
            }
        } else {
            
            
            handler(createTimelineEntry("Lowest Class", bodyText: "No Data to show", date: Date()))
            print("nothing to show")
        }
        
    }
    
    
   
    
    func createTimelineEntry(_ headerText: String, bodyText: String, date: Date) -> CLKComplicationTimelineEntry {
    
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
     
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.body1TextProvider = CLKSimpleTextProvider(text: bodyText)
        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        
        return entry
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDate(handler: (Date) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = CLKSimpleTextProvider(text: "Current Lowest Class Grade")
        template.body1TextProvider = CLKSimpleTextProvider(text: "Computer Science AP")
        handler(template)
    }
    
    
   
    
    
   
    
}
