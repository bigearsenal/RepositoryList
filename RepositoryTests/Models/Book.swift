import Foundation

struct Book: Hashable & Identifiable {
    var id = UUID()
    let name: String
}
