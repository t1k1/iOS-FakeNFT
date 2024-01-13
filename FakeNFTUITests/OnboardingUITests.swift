import XCTest

final class OnboardingUITests: XCTestCase {
    func testPagesSwipe() throws {
        let app = XCUIApplication()
        app.launch()
        sleep(3)
        app.swipeLeft()
        sleep(3)
        app.swipeLeft()
        sleep(3)
        XCTAssertTrue(app.buttons["ActionButton"].exists)
    }
}
