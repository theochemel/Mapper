import Foundation
import SwiftUI

struct ScanVisualizationView: View {
    @ObservedObject var scan: Scan
    
    var body: some View {
        TabView {
            Text("2D Floorplan View")
                .tabItem {
                    Text("2D Floorplan")
            }
            Text("3D Reconstruction View")
                .tabItem {
                    Text("3D Reconstruction")
            }
            MeshVisualizationHostView(mesh: self.scan.cleanedScan!.mesh)
                .tabItem {
                    Text("3D Mesh")
            }
        }
    }
}
