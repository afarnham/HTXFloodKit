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
		print("SERVICE: \(service)")
	}
	
    static var allTests = [
        ("testExample", testExample),
        ("testFetch", testFetch),
    ]
}
