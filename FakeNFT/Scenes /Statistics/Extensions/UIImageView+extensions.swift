//
//  UIImageView+extensions.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 03.01.2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func fetchAvatarBy(url: String, with radius: CGFloat, for imageView: UIImageView) {
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                    with: URL(string: url),
                    placeholder: Statistics.SfSymbols.iconProfile,
                    options: [.processor(RoundCornerImageProcessor(cornerRadius: radius))]
                )
         }
    }

    func fetchNftBy(url: String, for imageView: UIImageView) {
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: URL(string: url),
                placeholder: Statistics.SfSymbols.placeholderNft
            )
        }
    }

}
