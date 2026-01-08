import SwiftUI
import ReceiptCore

// Day 3: macOS receipts list + import button
struct ContentView: View {
    @State private var store = ReceiptStore()

    var body: some View {
        NavigationStack {
            List(store.receipts) { r in
                VStack(alignment: .leading, spacing: 4) {
                    Text(r.merchantName).font(.headline)
                    Text(r.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(r.assetFilenames.count) file(s)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Import") {
                        MacReceiptImporter.pickReceiptFiles { urls in
                            guard !urls.isEmpty else { return }
                            do {
                                let filenames = try ReceiptFileStoreMac.shared.importFiles(urls)
                                let receipt = Receipt(
                                    merchantName: "Imported Receipt",
                                    assetFilenames: filenames
                                )
                                Task { @MainActor in
                                    store.addReceipt(receipt)
                                }
                            } catch {
                                // keep simple for Day 3
                            }
                        }
                    }
                }
            }
        }
        .onAppear { store.load() }
    }
}
