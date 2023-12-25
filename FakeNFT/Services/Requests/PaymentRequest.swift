import Foundation

struct PaymentRequest: NetworkRequest {

    let currency_id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currency_id)")
    }
}
