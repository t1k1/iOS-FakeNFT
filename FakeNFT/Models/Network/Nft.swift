import Foundation

struct Nft: Decodable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: URL
    let id: String
}

struct NftForUse {
    let createdAt: Date
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: URL
    let id: String
}
