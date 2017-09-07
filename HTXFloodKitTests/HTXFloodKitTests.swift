//
//  HTXFloodKitTests.swift
//  HTXFloodKitTests
//
//  Created by Raymond Farnham on 9/6/17.
//  Copyright © 2017 TinyRobot. All rights reserved.
//

import XCTest
@testable import HTXFloodKit

class HTXFloodKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecodeGaugeCollectionJSON() {
        let testJSON = """
{
    "type": "FeatureCollection",
    "properties": {
        "DataRange": {
            "StartDate": "",
            "EndDate": "9/1/2017 5:05 PM CDT"
        }
    },
    "features": [
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    -95.025513,
                    29.554639
                ],
                "offset": [
                    -0.01998,
                    0.01067
                ],
                "Text": "A100_100 Clear Lake 2nd Outlet @ SH 146"
            },
            "properties": {
                "SiteId": 100,
                "SiteType": "Gate",
                "Rainfall": 0,
                "RainfallText": "0.00",
                "Description": "",
                "StreamData": [
                    {
                        "CurrentLevel": 1.43,
                        "CurrentReadingDate": "2017-09-01T16:57:32",
                        "ChannelInfo": {
                            "TOB": 7.7,
                            "BOC": -11.87,
                            "SensorId": 103,
                            "FloodStage": null,
                            "FloodLevelIndicator": null,
                            "NoFloodCategory": false
                        }
                    },
                    {
                        "CurrentLevel": 1.31,
                        "CurrentReadingDate": "2017-09-01T15:09:32",
                        "ChannelInfo": {
                            "TOB": 7.7,
                            "BOC": -9,
                            "SensorId": 104,
                            "FloodStage": null,
                            "FloodLevelIndicator": null,
                            "NoFloodCategory": false
                        }
                    }
                ]
            }
        }
    ]
}
"""
        guard let testData = testJSON.data(using: .utf8) else {
            XCTFail("Could convert JSON to Data")
            return
        }
        let decoder = JSONDecoder()
        let gauges = try! decoder.decode(GageCollection.self, from: testData)
        print(gauges)
    }
    
    func testService() {
        let service = HarrisFWSService()
        let expectation = XCTestExpectation(description: "test")
        service.requestGageCollection { (someGageCollection, someError) in
            print(someGageCollection)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
