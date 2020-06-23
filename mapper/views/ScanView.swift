import Foundation
import SwiftUI

struct ScanView: View {
    @ObservedObject var scan: Scan
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var dateCreatedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM y"
        return formatter.string(from: self.scan.dateCreated)
    }
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading, spacing: 12.0) {
                    Text(self.scan.name)
                        .font(.largeTitle)
                    HStack {
                        Text("Created on \(self.dateCreatedString)")
                        Spacer()
                        if self.scan.isScanCompleted {
                            Button(action: {
                                self.scan.refreshCleanedScan(backendURL: self.userDefaultsManager.backendURL)
                            }) {
                                Text("Reload")
                            }
                        }
                        Text("\(self.scan.address)  |  \(self.scan.floor)")
                    }
                    Divider()
                }.padding([.top, .leading, .trailing], 24.0)
                Spacer()
                if self.scan.isScanCompleted {
                    ScanVisualizationView(scan: self.scan)
                } else {
                    StartScanView(scan: self.scan)
                }
                Spacer(minLength: 0.0)
            }
        }
    }
}
