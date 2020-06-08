import Foundation
import SwiftUI

struct ScanListCellView: View {
    var scan: Scan
    var dateCreatedString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM y"
        guard let dateCreated = self.scan.dateCreated else { return nil }
        return formatter.string(from: dateCreated)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(scan.name ?? "Unknown")
                .font(.headline)
            Text(self.dateCreatedString ?? "Unknown")
                .font(.subheadline)
        }
    }
}
