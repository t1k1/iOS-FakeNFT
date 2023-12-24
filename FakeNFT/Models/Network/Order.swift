import UIKit

struct OrderNetworkModel: Decodable {
    let nfts: [String]
    let id: String
}

struct OrderResult {
    let nfts: [String]
    let id: String
}
