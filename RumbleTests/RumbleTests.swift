//
//  RumbleTests.swift
//  RumbleTests
//
//  Created by Yanbo Li on 3/27/17.
//  Copyright © 2017 Yanbo Li. All rights reserved.
//

import XCTest
@testable import Rumble

class RumbleTests: XCTestCase {
    
    func testMealInitializationSucceeds(){
        let smallMeal = Meal.init(name: "smallMeal", photo: nil, startTime: "10:00", endTime: "10:05")
        XCTAssertNotNil(smallMeal)
        
        let bigMeal = Meal.init(name: "bigMeal", photo: nil, startTime: "11:00", endTime: "13:00")
        XCTAssertNotNil(bigMeal)
    }
    
    func testMealInitializationFails() {
        let emptyStringMeal = Meal.init(name: "", photo: nil, startTime: "9:00", endTime: "10:00")
        XCTAssertNil(emptyStringMeal)
    }
    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
