import Foundation

struct Book: Hashable & Identifiable {
    var id: Int
    let name: String
    var refreshedCount: Int = 0
}
