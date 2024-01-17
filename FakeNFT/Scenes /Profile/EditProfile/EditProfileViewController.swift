//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 10.12.2023.
//

import UIKit

final class EditProfileViewController: UIViewController {
    weak var delegate: ProfileViewControllerDelegate?

    // MARK: - Layout variables
    private lazy var closeButton: UIButton = {
        let imageButton = UIImage(named: "close")?.withRenderingMode(.alwaysOriginal)

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)

        return button
    }()
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .ypBackgroundUniversal
        view.layer.cornerRadius = 35

        return view
    }()
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("Сменить \n фото", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(changeAvatar), for: .touchUpInside)

        return button
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Имя"

        return label
    }()
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGreyDay
        textField.font = .systemFont(ofSize: 17, weight: .regular)

        return textField
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Описание"

        return label
    }()
    private lazy var descriptionTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.returnKeyType = UIReturnKeyType.done
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGreyDay
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)

        return textView
    }()
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Сайт"

        return label
    }()
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGreyDay
        textField.font = .systemFont(ofSize: 17, weight: .regular)

        return textField
    }()

    private var likes: [String]?
    private let profileService = ProfileService.shared

    // MARK: - Initialization
    init(imageButton: UIImage?, name: String?, description: String?, webSite: String?, likes: [String]) {
        super.init(nibName: nil, bundle: nil)

        avatarImageView.image = imageButton
        nameTextField.text = name
        descriptionTextField.text = description
        urlTextField.text = webSite
        self.likes = likes
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateProfile()
    }
}

// MARK: - Private functions
private extension EditProfileViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay

        addSubViews()
        configureConstraints()
        addTapGestureToHideKeyboard()
    }

    func addSubViews() {
        view.addSubview(closeButton)
        view.addSubview(avatarImageView)
        view.addSubview(shadowView)
        view.addSubview(changePhotoButton)

        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(urlLabel)
        view.addSubview(urlTextField)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),

            shadowView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),

            changePhotoButton.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            changePhotoButton.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            changePhotoButton.topAnchor.constraint(equalTo: shadowView.topAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 50),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 117),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28),

            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 132),

            urlLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            urlLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            urlLabel.widthAnchor.constraint(equalToConstant: 57),
            urlLabel.heightAnchor.constraint(equalToConstant: 28),

            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            urlTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            urlTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc
    func close() {
        dismiss(animated: true)
    }

    @objc
    func changeAvatar() {

    }
}

private extension EditProfileViewController {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    func updateProfile() {
        guard let likes = likes else { return }
        let profileUpdate = ProfileUpdate(
            name: nameTextField.text ?? "",
            description: descriptionTextField.text,
            website: urlTextField.text ?? "",
            likes: likes
        )
        profileService.updateProfile(with: profileUpdate) { [weak self] result in
            guard let self = self,
                  let delegate = self.delegate else {
                return
            }
            switch result {
            case .success:
                delegate.updateProfile()
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }

    @objc
    func tapGesture() {
        descriptionTextField.resignFirstResponder()
    }
}
