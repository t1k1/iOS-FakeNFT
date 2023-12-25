import UIKit

struct PaymentNetworkModel: Codable {
    let success: Bool
    let orderId: String
    let id: String
}

struct PaymentResultModel {
    let success: Bool
    let orderId: String
    let id: String
}

