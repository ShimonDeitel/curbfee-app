import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [DuePayment] = []
    @Published var isPro: Bool = false

    /// Free tier allows this many entries. Seed data below is always fewer than this
    /// so a fresh install never opens straight into the paywall.
    static let freeLimit = 20

    private let fileName = "curbfee_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([DuePayment].self, from: data) else {
            items = Self.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Self.freeLimit
    }

    @discardableResult
    func add(_ item: DuePayment) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: DuePayment) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: DuePayment) {
        items.removeAll { $0.id == item.id }
        save()
    }

    static func seedData() -> [DuePayment] {
        [
        DuePayment(dueDate: Date().addingTimeInterval(-259200), amount: 3.5, isPaid: true, community: "Maple Ridge HOA", notes: ""),
        DuePayment(dueDate: Date().addingTimeInterval(-518400), amount: 5.75, isPaid: false, community: "Oak Grove", notes: "Weekly run"),
        DuePayment(dueDate: Date().addingTimeInterval(-777600), amount: 8.0, isPaid: true, community: "Maple Ridge HOA", notes: ""),
        DuePayment(dueDate: Date().addingTimeInterval(-1036800), amount: 10.25, isPaid: false, community: "Oak Grove", notes: "Weekly run")
        ]
    }
}
