import UIKit

struct ErrorModel {
    let title: String
    let message: String
    let actionText: String
    let action: () -> Void
    var secondActionText: String?
    var secondAction: (() -> Void)?

    init(title: String, message: String, actionText: String, action: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.actionText = actionText
        self.action = action
    }

    mutating func setSecondAction(_ completion: (() -> Void)?) {
        self.secondAction = completion
    }

    mutating func setSecondActionText(_ text: String?) {
        self.secondActionText = text
    }

}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let title = model.title
        let alert = UIAlertController(
            title: title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: model.actionText, style: UIAlertAction.Style.default) {_ in
            model.action()
        }
        alert.addAction(action)
        if model.secondActionText != nil {
            let secondAction = UIAlertAction(title: model.secondActionText, style: UIAlertAction.Style.default) {_ in
                (model.secondAction ?? {})()
            }
            alert.addAction(secondAction)
        }
        present(alert, animated: true)
    }
}
