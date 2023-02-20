import Foundation

struct BooksListSection: ListSection {
    var id: String
    var items: [Book]
    var loadingState: LoadingState
    var error: String?
    
    var name: String {
        "Page \(id)"
    }
}
