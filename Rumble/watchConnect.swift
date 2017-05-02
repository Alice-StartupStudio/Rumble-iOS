//
//  watchConnect.swift
//  Rumble
//
//  Created by Yanbo Li on 3/28/17.
//  Copyright © 2017 Yanbo Li. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity

class ConnectivityHandler : NSObject, WCSessionDelegate {
    var session = WCSession.default()
    
    dynamic var messages = [Meal]()
    
    override init(){
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("didReceiveMessage: %@", message)
        
        let msg = message["type"]!
        
        if(String(describing: msg) == "AddMeal") {
            let photo = UIImage(named: "lunch")
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let startTime = String(hour) + ":" + String(minutes)
            let endTime = startTime
            
            let meal = Meal(name: "meal", photo: photo, startTime: startTime, endTime: endTime)
//            meals.append(meal!)
            self.messages.append(meal!)

            for m in meals {
                print(m)
            }
        }
        
//        if message["request"] as? String == "date" {
//            replyHandler(["date" : "\(Date())"])
//        }
    }
    
}
