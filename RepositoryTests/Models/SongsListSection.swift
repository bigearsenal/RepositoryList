import Foundation

struct SongsListSection: ListSection {
    var id: String
    var items: [Song]
    var loadingState: LoadingState
    var error: String?
    
    var name: String {
        "Page \(id)"
    }
}
