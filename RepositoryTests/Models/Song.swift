import Foundation

struct Song: Hashable & Identifiable {
    var id: String { name }
    let name: String
    let systemImage: String
}
