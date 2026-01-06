import Foundation

// Day 3: macOS store + file store
final class ReceiptFileStoreMac {
    static let shared = ReceiptFileStoreMac()
    private init() {}

    private let folderName = "Receipts"

    private var receiptsFolderURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent(folderName, isDirectory: true)
    }

    func ensureFolderExists() throws {
        let url = receiptsFolderURL
        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }

    /// Copies selected files into the sandbox Receipts folder.
    /// Returns filenames (not full paths).
    func importFiles(_ urls: [URL]) throws -> [String] {
        try ensureFolderExists()

        var filenames: [String] = []
        filenames.reserveCapacity(urls.count)

        for url in urls {
            let ext = url.pathExtension.isEmpty ? "dat" : url.pathExtension
            let filename = "\(UUID().uuidString).\(ext)"
            let dest = receiptsFolderURL.appendingPathComponent(filename)

            // Copy file into sandbox. If it exists (rare), replace.
            if FileManager.default.fileExists(atPath: dest.path) {
                try FileManager.default.removeItem(at: dest)
            }
            try FileManager.default.copyItem(at: url, to: dest)
            filenames.append(filename)
        }

        return filenames
    }

    func fileURL(for filename: String) -> URL {
        receiptsFolderURL.appendingPathComponent(filename)
    }
}
