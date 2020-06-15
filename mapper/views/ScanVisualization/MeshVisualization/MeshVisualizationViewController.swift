import Foundation
import UIKit

class MeshVisualizationViewController: UIViewController {
    
    var mesh: Mesh!
    var meshVisualizationView: MeshVisualizationView!
    private var drawPointCloud = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.meshVisualizationView = MeshVisualizationView()
        self.view = self.meshVisualizationView
        
        self.meshVisualizationView.pointCloudToggle.addTarget(self, action: #selector(self.toggleDidChange(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.meshVisualizationView.draw(mesh: self.mesh)
    }
    
    @objc private func toggleDidChange(_ sender: UISegmentedControl) {
        let shouldDrawPointCloud = sender.selectedSegmentIndex == 1
        self.meshVisualizationView.draw(mesh: self.mesh, shouldDrawPointCloud: shouldDrawPointCloud)
    }
}
