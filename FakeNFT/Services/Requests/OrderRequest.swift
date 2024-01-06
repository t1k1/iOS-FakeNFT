import Foundation

struct OrderRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}

struct OrderPutRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }

    var httpMethod = HttpMethod.put
    var dto: Encodable?
    var body: Data?

    init(order: OrderNetworkModel) {
        var nfts = ""
        order.nfts.enumerated().forEach { (_, nft) in
            nfts += "\(OrderPutRequestConstants.nfts)=\(nft)&"
        }
        nfts += "\(OrderPutRequestConstants.id)=\(order.id)"
        let dataString = nfts
        self.body = dataString.data(using: .utf8)
        let id = "1"
        let orderToPut = OrderNetworkModel(nfts: order.nfts, id: id)
        self.dto = orderToPut
        self.id = orderToPut.id
    }

    private enum OrderPutRequestConstants {
        static let id = "id"
        static let nfts = "nfts"
    }

}
