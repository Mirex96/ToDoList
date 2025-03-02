import Foundation
import RealmSwift


struct Task {
    let id: String
    let category: Category
    let caption: String
    let createdDate: Date
    var isComplete: Bool
}

class LocalTasc: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var category = Category.study
    @Persisted var caption = ""
    @Persisted var createdDate = Date()
    @Persisted var isComplete = false
}
