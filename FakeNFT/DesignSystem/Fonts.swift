import UIKit

extension UIFont {
    // Ниже приведены примеры шрифтов, настоящие шрифты надо взять из фигмы

    // Headline Fonts

    /// SF Pro, size 34, bold
    static var headline1 = UIFont.systemFont(ofSize: 34, weight: .bold)

    /// SF Pro, size 28, bold
    static var headline2 = UIFont.systemFont(ofSize: 28, weight: .bold)

    /// SF Pro, size 22, bold
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)

    /// SF Pro, size 20, bold
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)

    // Body Fonts

    /// SF Pro, size 17, regular
    static var bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)

    /// SF Pro, size 17, bold
    static var bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)

    // Caption Fonts

    /// SF Pro, size 15, regular
    static var caption1 = UIFont.systemFont(ofSize: 15, weight: .regular)

    /// SF Pro, size 13, regular
    static var caption2 = UIFont.systemFont(ofSize: 13, weight: .regular)

    /// SF Pro, size 10, medium
    static var caption3 = UIFont.systemFont(ofSize: 10, weight: .medium)
}
