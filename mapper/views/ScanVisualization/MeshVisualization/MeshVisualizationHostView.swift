import Foundation
import SwiftUI

struct MeshVisualizationHostView: UIViewControllerRepresentable {
    var mesh: Mesh
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MeshVisualizationHostView>) -> MeshVisualizationViewController {
        let meshVisualizationViewController = MeshVisualizationViewController()
        meshVisualizationViewController.mesh = self.mesh
        return meshVisualizationViewController
    }
    
    func updateUIViewController(_ uiViewController: MeshVisualizationViewController, context: UIViewControllerRepresentableContext<MeshVisualizationHostView>) {
    }
}
