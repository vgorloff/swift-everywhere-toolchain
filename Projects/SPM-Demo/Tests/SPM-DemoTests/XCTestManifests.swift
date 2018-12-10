import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SPM_DemoTests.allTests),
    ]
}
#endif