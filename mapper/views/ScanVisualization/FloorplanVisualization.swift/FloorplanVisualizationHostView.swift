import Foundation
import SwiftUI

struct FloorplanVisualizationHostView: UIViewControllerRepresentable {
    var floorplan: Floorplan
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FloorplanVisualizationHostView>) -> FloorplanVisualizationViewController {
        let floorplanVisualizationViewController = FloorplanVisualizationViewController()
        floorplanVisualizationViewController.floorplan = floorplan
        return floorplanVisualizationViewController
    }
    
    func updateUIViewController(_ uiViewController: FloorplanVisualizationViewController, context: UIViewControllerRepresentableContext<FloorplanVisualizationHostView>) {
        
    }
}
