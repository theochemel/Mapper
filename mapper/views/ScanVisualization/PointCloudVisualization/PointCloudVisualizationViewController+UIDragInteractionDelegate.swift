import Foundation
import UIKit

extension PointCloudVisualizationViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        guard let path = self.pointCloud.plyFilePath, let provider = NSItemProvider(contentsOf: path) else { return [] }
        return [UIDragItem(itemProvider: provider)]
    }
}
