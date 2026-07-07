import XCTest
@testable import Curbfee

@MainActor
final class CurbfeeTests: XCTestCase {
    func makeIsolatedStore() -> Store {
        Store()
    }

    func testSeedDataUnderFreeLimit() {
        let store = makeIsolatedStore()
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = makeIsolatedStore()
        let before = store.items.count
        let added = store.add(DuePayment())
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = makeIsolatedStore()
        let item = DuePayment()
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeIsolatedStore()
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        let store = makeIsolatedStore()
        store.isPro = false
        store.items = Array(repeating: DuePayment(), count: Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        XCTAssertFalse(store.add(DuePayment()))
    }

    func testProBypassesLimit() {
        let store = makeIsolatedStore()
        store.isPro = true
        store.items = Array(repeating: DuePayment(), count: Store.freeLimit)
        XCTAssertTrue(store.canAddMore)
        XCTAssertTrue(store.add(DuePayment()))
    }

    func testUpdateModifiesExistingItem() {
        let store = makeIsolatedStore()
        var item = DuePayment()
        store.add(item)
        item.community = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.community, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = makeIsolatedStore()
        store.items = [DuePayment(), DuePayment()]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }
}
