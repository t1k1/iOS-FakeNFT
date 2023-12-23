import UIKit

struct NftNetworkModel: Decodable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: URL
    let id: String
}

struct NftResultModel {
    let createdAt: Date
    let name: String
    let image: UIImage?
    let rating: Int
    let description: String
    let price: Float
    let author: URL
    let id: String
}
