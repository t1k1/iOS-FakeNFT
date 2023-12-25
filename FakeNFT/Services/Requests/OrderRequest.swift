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
        order.nfts.enumerated().forEach { (index, nft) in
            nfts += "nfts=\(nft)&"
        }
        let id = "1"
        nfts += "id=\(id)"
        let dataString = nfts
        self.body = dataString.data(using: .utf8)
        
        let orderToPut = OrderNetworkModel(nfts: order.nfts, id: "1")
        self.dto = orderToPut
        self.id = "1"
    }
    
}
