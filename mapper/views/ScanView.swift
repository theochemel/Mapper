import Foundation
import SwiftUI

struct ScanView: View {
    @ObservedObject var scan: Scan
    var dateCreatedString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM y"
        guard let dateCreated = self.scan.dateCreated else { return nil }
        return formatter.string(from: dateCreated)
    }
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading, spacing: 12.0) {
                    Text(self.scan.name ?? "Unknown")
                        .font(.largeTitle)
                    HStack {
                        Text("Created on \(self.dateCreatedString ?? "Unknown")")
                        Spacer()
                        Text("\(self.scan.address ?? "null") |  \(self.scan.floor ?? "null")")
                    }
                    Divider()
                }.padding([.top, .leading, .trailing], 24.0)
                Spacer()
                if self.scan.isScanCompleted {
                    ScanVisualizationView()
                } else {
                    StartScanView(scan: self.scan)
                }
                Spacer(minLength: 0.0)
            }
            Spacer()
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    
    static var previews: some View {
        let scan = Scan()
        scan.name = "Test Scan"
        scan.dateCreated = Date()
        return ScanView(scan: scan)
    }
}
