import SwiftUI
import ReceiptCore

// Day 2: iOS UI: List + “Add Receipt” button
struct ContentView: View {
    @StateObject private var store = ReceiptStore() // database for receipts (in-memory + JSON on disk)
    @State private var showScanner = false

    var body: some View {
        NavigationStack {
            List(store.receipts) { r in
                VStack(alignment: .leading, spacing: 4) {
                    Text(r.merchantName).font(.headline)
                    Text(r.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(r.assetFilenames.count) page(s)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showScanner = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear { store.load() }      // loads receipts.json from disk and populates store.receipts so receipts persist after closing and opening app
        .sheet(isPresented: $showScanner) {
            DocumentScannerView(
                onComplete: { images in
                    do {
                        let filenames = try ReceiptFileStore.shared.saveScannedPages(images) // save images to disk
                        let receipt = Receipt(assetFilenames: filenames) // create a receipt record referencing those files
                        store.addReceipt(receipt) // add it to the store (updates UI & saves JSON)
                    } catch {
                        // keep simple for Day 2
                    }
                    showScanner = false
                },
                onCancel: {
                    showScanner = false
                }
            )
        }
    }
}


#Preview {
    ContentView()
}
