import UIKit

struct Cripto: Decodable {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct CriptoViewModel {
    let title: String
    let name: String
    let image: UIImage
    let id: String
}

