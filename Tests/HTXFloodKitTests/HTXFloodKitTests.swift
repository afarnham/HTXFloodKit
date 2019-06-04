import XCTest
@testable import HTXFloodKit

class HTXFloodKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HTXFloodKit().text, "Hello, World!")
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

    static var allTests = [
        ("testService", testService),
    ]
}
