//
//  MealDataModel.swift
//  Rumble
//
//  Created by Yanbo Li on 3/27/17.
//  Copyright © 2017 Yanbo Li. All rights reserved.
//

import UIKit
import os.log

var cellColors: [String:String] = ["Salad":"c6e4ec",
                                   "Snack":"fce4b6",
                                   "Apple":"fce4b6",
                                   "Water":"f6bebb",
                                   "Migraine":"D3D3D3"]

class Meal: NSObject, NSCoding {
    
    // MARK: Properties
    var name: String = ""
    var photo: UIImage?
    var startTime: String = ""
    var endTime: String = ""
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    //MART: Types
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
        static let startTime = "startTime"
        static let endTime = "endTime"
    }
    
    // Initialization
    init?(name: String, photo: UIImage?, startTime: String, endTime: String) {
        
        if name.isEmpty || startTime.isEmpty {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.startTime = startTime
        self.endTime = endTime
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(startTime, forKey: PropertyKey.startTime)
        aCoder.encode(endTime, forKey: PropertyKey.endTime)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let startTime = aDecoder.decodeObject(forKey: PropertyKey.startTime) as? String
        let endTime = aDecoder.decodeObject(forKey: PropertyKey.endTime) as? String
        
        // Call designated initializer.
        self.init(name:name, photo:photo, startTime:startTime!, endTime:endTime!)
    }
}
