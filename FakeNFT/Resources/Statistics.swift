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
    }

    // MARK: - UI element's images
    enum Images {
        static let iconCart = UIImage(named: "cart")
        static let iconSort = UIImage(named: "Sort")
        static let backward = UIImage(named: "backward")
    }
    enum Labels {
        static let tabBarStatistics = NSLocalizedString("Tab.statistics", comment: "")

        static let sortingTitle = NSLocalizedString("statistics.sort.title", comment: "")
        static let sortingByName = NSLocalizedString("statistics.sort.byName", comment: "")
        static let sortingByRating = NSLocalizedString("statistics.sort.byRating", comment: "")
        static let sortingClose = NSLocalizedString("statistics.sort.close", comment: "")
        static let collectionTitle = NSLocalizedString("statistics.collection.title", comment: "")
        static let siteButtonTitle = NSLocalizedString("statistics.siteButton.title", comment: "")
    }

    enum Dimensions {
        static let icon42: CGFloat = 42
        static let icon40: CGFloat = 40
        static let icon32: CGFloat = 32
        static let radius12: CGFloat = 12
    }

    enum Layouts {
        static let leading16: CGFloat = 16
        static let spacing20: CGFloat = 20
        static let spacing8: CGFloat = 8
    }
}
