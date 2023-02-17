import Foundation

struct Book: Hashable & Identifiable {
    var id: String { name }
    let name: String
}
