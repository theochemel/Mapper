import Foundation
import SwiftUI

struct ScanVisualizationView: View {
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
            Text("3D Mesh")
                .tabItem {
                    Text("3D Mesh")
            }
        }
    }
}
