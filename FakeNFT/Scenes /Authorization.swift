import UIKit
final class AuthorizationViewController: UIViewController {

    // MARK: - Private mutable properties
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("authorization.viewController.mainLabel", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.ypBlackDay
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var userTextField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("authorization.viewController.emailPlaceholder", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGrayUniversal ?? .gray]
        )
        field.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        field.backgroundColor = UIColor.ypLightGreyDay
        field.clearButtonMode = .whileEditing
        field.textPadding = UIEdgeInsets(top: 11, left: 16, bottom: 13, right: 16)
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var passwordTextField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("authorization.viewController.passwordPlaceholder", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGrayUniversal ?? .gray]
        )
        field.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        field.backgroundColor = UIColor.ypLightGreyDay
        field.clearButtonMode = .whileEditing
        field.textPadding = UIEdgeInsets(top: 11, left: 16, bottom: 13, right: 16)
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 12
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.setTitle(NSLocalizedString("authorization.viewController.loginButtonTitle", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor.ypBlackDay
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        button.setTitle(NSLocalizedString("authorization.viewController.forgotPasswordButton", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypBlackDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        button.setTitle(NSLocalizedString("authorization.viewController.registerButton", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypBlackDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - View controller lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhiteDay
        configureConstraints()
    }

    // MARK: - Objective-C functions
    @objc
    private func didTapLoginButton() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration of switchToTabBarController") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }

    @objc func didTapForgotPassword() {
        print("Forgot password tapped")
    }

    @objc func didTapRegisterButton() {
        print("Register tapped")
    }
}

// MARK: - Configure constraints
private extension AuthorizationViewController {
    func configureConstraints() {
        view.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 176)
        ])

        view.addSubview(userTextField)
        NSLayoutConstraint.activate([
            userTextField.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: 61),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userTextField.heightAnchor.constraint(equalToConstant: 46)
        ])

        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 46)
        ])

        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 84),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        view.addSubview(forgotPasswordButton)
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 18)
        ])

        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            registerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
