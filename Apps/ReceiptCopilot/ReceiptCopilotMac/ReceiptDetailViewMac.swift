import SwiftUI
import ReceiptCore
import PDFKit

// Day 3: preview saved PDFs
struct ReceiptDetailViewMac: View {
    let receipt: Receipt

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(receipt.merchantName).font(.title2)
            Text(receipt.createdAt.formatted()).foregroundStyle(.secondary)

            if let first = receipt.assetFilenames.first {
                ReceiptPreviewMac(filename: first)
                    .frame(minHeight: 500)
            } else {
                Text("No files")
            }
        }
        .padding()
    }
}

private struct ReceiptPreviewMac: View {
    let filename: String

    var body: some View {
        let url = ReceiptFileStoreMac.shared.fileURL(for: filename)
        if filename.lowercased().hasSuffix(".pdf") {
            PDFKitView(url: url)
        } else if let nsImage = NSImage(contentsOf: url) {
            Image(nsImage: nsImage)
                .resizable()
                .scaledToFit()
        } else {
            Text("Preview unavailable")
        }
    }
}

private struct PDFKitView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> PDFView {
        let v = PDFView()
        v.autoScales = true
        v.document = PDFDocument(url: url)
        return v
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = PDFDocument(url: url)
    }
}
