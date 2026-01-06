import AppKit
import UniformTypeIdentifiers

// Uses AppKit (NSOpenPanel) to implement macOS "import receipt"
// opens native file picker so user can select receipt files to import
enum MacReceiptImporter {
    static func pickReceiptFiles(completion: @escaping ([URL]) -> Void) {
        // file picker dialog
        let panel = NSOpenPanel()
        panel.title = "Import Receipt"
        
        // multiple selection of receipts
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true

        // Restrict file types: Allow PDFs and common images
        panel.allowedContentTypes = [
            .pdf, .jpeg, .png, .tiff
        ]

        // asynchronous result: begin shows thr panel without blocking the UI
        panel.begin { response in
            guard response == .OK else {
                completion([])
                return
            }
            completion(panel.urls)
        }
    }
}


