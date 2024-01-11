import Foundation

struct PaymentRequest: NetworkRequest {

    let currencyID: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyID)")
    }
}
