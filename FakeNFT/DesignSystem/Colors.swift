import UIKit

extension UIColor {

    static var ypBlackDay: UIColor! { UIColor(named: "Black [day]")}
    static var ypLightGreyDay: UIColor! { UIColor(named: "Light grey [day]")}
    static var ypWhiteDay: UIColor! { UIColor(named: "White [day]")}

    static var ypBackgroundUniversal: UIColor! { UIColor(named: "Background Universal")}
    static var ypBlackUniversal: UIColor! { UIColor(named: "Black Universal")}
    static var ypBlueUniversal: UIColor! { UIColor(named: "Blue Universal")}
    static var ypGrayUniversal: UIColor! { UIColor(named: "Gray Universal")}
    static var ypGreenUniversal: UIColor! { UIColor(named: "Green Universal")}
    static var ypRedUniversal: UIColor! { UIColor(named: "Red Universal")}
    static var ypYellowUniversal: UIColor! { UIColor(named: "Yellow Universal")}
    static var ypWhiteUniversal: UIColor! { UIColor(named: "White Universal")}

    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // Text Colors
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor.gray
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black

    private static let yaBlackLight = UIColor(hexString: "1A1B22")
    private static let yaBlackDark = UIColor.white
    private static let yaLightGrayLight = UIColor(hexString: "#F7F7F8")
    private static let yaLightGrayDark = UIColor(hexString: "#2C2C2E")

    static let segmentActive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }

    static let segmentInactive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayDark
        : .yaLightGrayLight
    }

    static let closeButton = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }
}
