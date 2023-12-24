import Foundation

struct NFTRequestTest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
