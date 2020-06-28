import Foundation
import UIKit

extension PointCloudVisualizationViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        guard let provider = NSItemProvider(contentsOf: self.pointCloud.plyPath) else { return [] }
        print(self.pointCloud.plyPath)
        return [UIDragItem(itemProvider: provider)]
    }
}
