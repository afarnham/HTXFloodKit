import XCTest
@testable import HTXFloodKit

class HTXFloodKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HTXFloodKit().text, "Hello, World!")
    }


	func testFetch() {
		let service = HarrisFWSService()
		let expectation = XCTestExpectation(description: "Download Flood Warning Service Gage info")
    	service.requestGageCollection { someGageCollection, someError in
    		if let gageCollection = someGageCollection {
	    		print("Gage Data: \(gageCollection)")
    			expectation.fulfill()    			
    		} else {
    			XCTFail("No gage data fetched")
    		}
    	}
    	wait(for: [expectation], timeout: 10)
	}
	
    static var allTests = [
        ("testExample", testExample),
        ("testFetch", testFetch),
    ]
}
