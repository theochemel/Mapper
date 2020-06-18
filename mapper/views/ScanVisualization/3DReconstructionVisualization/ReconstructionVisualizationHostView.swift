import Foundation
import SwiftUI
import SceneKit

struct ReconstructionVisualizationHostView: UIViewControllerRepresentable {
    var reconstruction: Reconstruction
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ReconstructionVisualizationHostView>) -> ReconstructionVisualizationViewController {
        let reconstructionVisualizationViewController = ReconstructionVisualizationViewController()
        reconstructionVisualizationViewController.reconstruction = self.reconstruction
        return reconstructionVisualizationViewController
    }
    
    func updateUIViewController(_ uiViewController: ReconstructionVisualizationViewController, context: UIViewControllerRepresentableContext<ReconstructionVisualizationHostView>) {
        
    }
}
