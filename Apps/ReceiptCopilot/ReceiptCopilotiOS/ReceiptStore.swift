import Foundation
import ReceiptCore

// Day 2: Persist receipts list as JSON
@MainActor
final class ReceiptStore: ObservableObject {
    @Published private(set) var receipts: [Receipt] = []

    private let storeFilename = "receipts.json"

    // where receipts are stored on disk
    private var storeURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent(storeFilename)
    }

    // reads receipts.json, decodes it into [Receipt]
    func load() {
        do {
            let data = try Data(contentsOf: storeURL)
            receipts = try JSONDecoder().decode([Receipt].self, from: data)
        } catch {
            receipts = []
        }
    }

    // converts [Receipt] to JSON bytes, writes it to disk
    func save() {
        do {
            let data = try JSONEncoder().encode(receipts)
            try data.write(to: storeURL, options: [.atomic])
        } catch {
            // Keep it simple for MVP; later you can show an error toast.
        }
    }

    // inserts new receipts at the top so newest appears first, immediately saves to disk
    func addReceipt(_ receipt: Receipt) {
        receipts.insert(receipt, at: 0)
        save()
    }
}

