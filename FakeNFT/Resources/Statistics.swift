//
//  Statistics.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 10.12.2023.
//

import UIKit

// MARK: - Resources for Statistics' epic

enum Statistics {

    // MARK: - UI element's SF symbols
    enum SfSymbols {
        static let iconProfile = UIImage(systemName: "person.circle.fill")
        static let iconCatalog = UIImage(systemName: "square.stack.3d.up.fill")
        static let iconCart = UIImage(systemName: "bag.fill")
        static let iconStatistics = UIImage(systemName: "flag.2.crossed.fill")

        static let iconStar = UIImage(systemName: "star.fill")
        static let iconSort = UIImage(systemName: "text.alignleft")

        static let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .large)
        static let forward = UIImage(systemName: "chevron.forward", withConfiguration: largeConfig)
        static let backward = UIImage(systemName: "chevron.backward", withConfiguration: largeConfig)

        static let like = UIImage(systemName: "heart.fill")
        static let placeholderNft = UIImage(systemName: "photo")
    }

    // MARK: - UI element's images
    enum Images {
        static let iconCartEmpty = UIImage(named: "cart empty")
        static let iconCartDelete = UIImage(named: "cart delete")
        static let iconSort = UIImage(named: "sort")

        static let nft1 = UIImage(named: "nft1")
        static let nft2 = UIImage(named: "nft2")
        static let nft3 = UIImage(named: "nft3")
        static let nft4 = UIImage(named: "nft4")
        static let nft5 = UIImage(named: "nft5")

//        static let avatar1 = UIImage(named: "avatar1")
//        static let avatar2 = UIImage(named: "avatar2")
//        static let avatar3 = UIImage(named: "avatar3")
    }

    // MARK: - UI element's labels
    enum Labels {
        static let tabBarStatistics = NSLocalizedString("Tab.statistics", comment: "")

        static let sortingTitle = NSLocalizedString("statistics.sort.title", comment: "")
        static let sortingByName = NSLocalizedString("statistics.sort.byName", comment: "")
        static let sortingByRating = NSLocalizedString("statistics.sort.byRating", comment: "")
        static let sortingClose = NSLocalizedString("statistics.sort.close", comment: "")
        static let collectionTitle = NSLocalizedString("statistics.collection.title", comment: "")
        static let siteButtonTitle = NSLocalizedString("statistics.siteButton.title", comment: "")
        static let arrowDownValue = "   ↓" // "   \u{2193}"
        static let arrowUpValue = "   ↑" // "   \u{2191}"
        static let arrowUp = "   △" // "   \u{25B3}"
        static let arrowDown = "   ▽" // "   ▽\u{25BD}"
    }
}
