//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 08.12.2023.
//

import UIKit

final class CatalogViewController: UIViewController {
  var button = UIButton()
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    // button.titleLabel = "test"
    view.addSubview(button)
  }
}
