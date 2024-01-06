import UIKit

struct OrderNetworkModel: Codable {
    let nfts: [String]
    let id: String
}

struct OrderResultModel {
    let nfts: [String]
    let id: String
}
