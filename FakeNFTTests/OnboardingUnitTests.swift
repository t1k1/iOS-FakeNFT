@testable import FakeNFT
import XCTest

final class OnboardingUnitTests: XCTestCase {
    func testViewDidLoad() {
        // given
        let viewController = OnboardingViewController()
        // when
        viewController.viewDidLoad()
        // then
        XCTAssertTrue(viewController.isViewLoaded)
    }
}
