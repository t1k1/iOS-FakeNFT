import UIKit
final class TextFieldWithPadding: UITextField {
    
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 16,
        bottom: 10,
        right: 16
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        return rect.offsetBy(dx: -8, dy: 0)
    }
}
