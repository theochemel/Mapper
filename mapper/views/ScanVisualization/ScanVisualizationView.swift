import Foundation
import SwiftUI

struct ScanVisualizationView: View {
    @ObservedObject var scan: Scan
    
    var body: some View {
        TabView {
            Group {
                if self.scan.isFloorplanCompleted {
                    FloorplanVisualizationHostView(floorplan: self.scan.floorplan!)
                } else {
                    Text("2D Floorplan View")
                }
            } .tabItem { Text("2D Floorplan") }
            
            Group {
                if self.scan.isReconstructionCompleted {
                    ReconstructionVisualizationHostView(reconstruction: self.scan.reconstruction!)
                } else {
                    Text("3D Reconstruction")
                }
            } .tabItem { Text("3D Reconstruction") }
            
            Group {
                if self.scan.isPointCloudCompleted {
                    PointCloudVisualizationHostView(pointCloud: self.scan.pointCloud!)
                } else {
                    Text("Point Cloud")
                }
            } .tabItem { Text("Point Cloud") }
        }
    }
}
