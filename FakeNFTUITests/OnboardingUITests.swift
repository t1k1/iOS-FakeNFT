import XCTest

final class OnboardingUITests: XCTestCase {
    func testPagesSwipe() throws {
        let app = XCUIApplication()
        app.launch()
        sleep(3)
        // wait for first screen
        app.swipeLeft()
        sleep(3)
        // wait for second screen
        app.swipeLeft()
        sleep(3)
        // wait for third screen, check that close button exists
        XCTAssertTrue(app.buttons["ActionButton"].exists)
    }
}
