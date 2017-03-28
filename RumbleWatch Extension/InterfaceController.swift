//
//  InterfaceController.swift
//  RumbleWatch Extension
//
//  Created by Yanbo Li on 3/28/17.
//  Copyright © 2017 Yanbo Li. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    // MARK: WCSessionDelegate
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Dummy Implementation
    }
//    var session: WCSession?
    
    fileprivate let session : WCSession? = WCSession.isSupported() ? WCSession.default() : nil

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

//        if (WCSession.isSupported()) {
//            session = WCSession.default()
            session?.delegate = self
            session?.activate()
//        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

    // MARK: Action
    
    @IBAction func addMeal() {
        if let session = session, session.isReachable {
            session.sendMessage(["type": "AddMeal"],
                                replyHandler: { replyData in
                                    print(replyData)
            }, errorHandler: { error in
                NSLog("%@", "Error sending message: \(error)")
            })
        } else {
            NSLog("%@", "Error sending message.")
        }
        WKInterfaceDevice.current().play(.notification)
    }
    
    @IBAction func addWater() {
        if let session = session, session.isReachable {
            session.sendMessage(["type": "AddWater"],
                                replyHandler: { replyData in
                                    print(replyData)
            }, errorHandler: { error in
                NSLog("%@", "Error sending message: \(error)")
            })
        } else {
            NSLog("%@", "Error sending message.")
        }
        WKInterfaceDevice.current().play(.notification)
    }
    
    
    @IBAction func addMigraine() {
        if let session = session, session.isReachable {
            session.sendMessage(["type": "AddMigraine"],
                                replyHandler: { replyData in
                                    print(replyData)
            }, errorHandler: { error in
                //                print(error)
                NSLog("%@", "Error sending message: \(error)")
            })
        } else {
            NSLog("%@", "Error sending message.")
        }
        WKInterfaceDevice.current().play(.notification)
    }
    

}
