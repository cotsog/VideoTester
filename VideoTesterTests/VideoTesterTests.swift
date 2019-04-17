//
//  VideoTesterTests.swift
//  VideoTesterTests
//
//  Created by Mac on 4/17/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import XCTest

@testable import VideoTester

class VideoTesterTests: XCTestCase {

    var ferrari:Car!
    var jeep:Car!
    var honda:Car!
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        ferrari = Car(type: .Sport, transmissionMode: .Drive)
        jeep = Car(type: .OffRoad, transmissionMode: .Drive)
        honda = Car(type: .Economy, transmissionMode: .Park)
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
        ferrari = nil
        jeep = nil
        honda = nil

    }

    func testSportFasterThanJeep() {
        let minutes = 60
        //1 start ferrari
        ferrari.start(minutes: minutes)
        //2 start jeep
        jeep.start(minutes: minutes)
        //Test it
        XCTAssertTrue(ferrari.miles > jeep.miles)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
