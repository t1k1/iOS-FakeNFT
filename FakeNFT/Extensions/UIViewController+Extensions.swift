import UIKit

extension UIViewController {
    func presentBottomAlert(title: String, buttons: [String], completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        for (index, buttonTitle) in buttons.enumerated() {
            let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
                completion(index)
            }

            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("extensions.uiViewController.bottomAlertCancel", comment: ""),
            style: .cancel,
            handler: nil
        )
//        let cancelAction = UIAlertAction(title: Statistics.Labels.sortingClose, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func presentNetworkAlert(errorDescription: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Error.title", comment: ""),
            message: errorDescription,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: NSLocalizedString("Error.repeat", comment: ""), style: .default) { _ in
            completion()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
