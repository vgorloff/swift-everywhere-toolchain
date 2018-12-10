import XCTest
@testable import SPM_Demo

final class SPM_DemoTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SPM_Demo().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
