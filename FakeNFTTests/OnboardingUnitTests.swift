@testable import FakeNFT
import XCTest

final class OnboardingUnitTests: XCTestCase {
    func testViewDidLoad() {
        let viewController = OnboardingViewController()
        viewController.viewDidLoad()
        XCTAssertTrue(viewController.isViewLoaded)
    }
}
