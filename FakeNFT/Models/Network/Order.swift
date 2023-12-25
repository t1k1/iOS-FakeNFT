import UIKit

struct OrderNetworkModel: Codable {
    let nfts: [String]
    let id: String
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(nfts, forKey: .nfts)
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nfts
//    }
}

struct OrderResultModel {
    let nfts: [String]
    let id: String
}
