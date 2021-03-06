import Foundation
import SwiftUI

struct ScanVisualizationView: View {
    @ObservedObject var scan: Scan
    
    private func isFloorplanCompleted() -> Bool {
        return self.scan.cleanedScan?.floorplan != nil
    }
    
    private func isReconstructionCompleted() -> Bool {
        return self.scan.cleanedScan?.reconstruction != nil
    }
    
    private func isPointCloudCompleted() -> Bool {
        return self.scan.cleanedScan?.pointCloud != nil
    }
    
    var body: some View {
        TabView {
            Group {
                if self.isFloorplanCompleted() {
                    FloorplanVisualizationHostView(floorplan: self.scan.cleanedScan!.floorplan!)
                } else {
                    Text("2D Floorplan View")
                }
            } .tabItem { Text("2D Floorplan") }
            
            Group {
                if self.isReconstructionCompleted() {
                    ReconstructionVisualizationHostView(reconstruction: self.scan.cleanedScan!.reconstruction!)
                } else {
                    Text("3D Reconstruction")
                }
            } .tabItem { Text("3D Reconstruction") }
            
            Group {
                if self.isPointCloudCompleted() {
                    PointCloudVisualizationHostView(pointCloud: self.scan.cleanedScan!.pointCloud!)
                } else {
                    Text("Point Cloud")
                }
            } .tabItem { Text("Point Cloud") }
        }
    }
}
