import Foundation
import UIKit
import SceneKit

class ReconstructionVisualizationViewController: UIViewController {
    
    var reconstruction: Reconstruction!
    var reconstructionVisualizationView: ReconstructionVisualizationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reconstructionVisualizationView = ReconstructionVisualizationView()
        self.view = self.reconstructionVisualizationView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let asset = self.reconstruction.asset {
            self.reconstructionVisualizationView.draw(asset: asset)
        }
    }
}
