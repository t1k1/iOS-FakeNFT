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
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("BottomAlert.Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
