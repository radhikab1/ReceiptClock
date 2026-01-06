import Foundation
import UIKit

final class ReceiptFileStore {
    static let shared = ReceiptFileStore()
    private init() {}

    private let folderName = "Receipts"

    // Choose persistent storage location in iOS sandbox
    private var receiptsFolderURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent(folderName, isDirectory: true)
    }

    // Create's a receipt folder if it doesn't exist
    func ensureFolderExists() throws {
        let url = receiptsFolderURL
        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }

    // Saves scanned images as JPEGs.
    func saveScannedPages(_ images: [UIImage]) throws -> [String] {
        try ensureFolderExists()

        var filenames: [String] = []
        filenames.reserveCapacity(images.count)

        // Returns unique filenames (not full paths) so it’s portable.
        for img in images {
            let filename = "\(UUID().uuidString).jpg"
            let fileURL = receiptsFolderURL.appendingPathComponent(filename)

            guard let data = img.jpegData(compressionQuality: 0.85) else { continue }
            try data.write(to: fileURL, options: [.atomic])

            filenames.append(filename)
        }

        return filenames
    }

    // Helper function: turn a filename to a full URL
    func fileURL(for filename: String) -> URL {
        receiptsFolderURL.appendingPathComponent(filename)
    }
}
