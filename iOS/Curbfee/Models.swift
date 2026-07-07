import Foundation

struct DuePayment: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var dueDate: Date
    var amount: Double
    var isPaid: Bool
    var community: String
    var notes: String

    init(id: UUID = UUID(), dueDate: Date = Date(), amount: Double = 0.0, isPaid: Bool = false, community: String = "", notes: String = "") {
        self.id = id
        self.dueDate = dueDate
        self.amount = amount
        self.isPaid = isPaid
        self.community = community
        self.notes = notes
    }
}
