import Foundation
import UIKit

extension ReconstructionVisualizationViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        guard let provider = NSItemProvider(contentsOf: self.reconstruction.ifcFilePath) else { return [] }
            
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
}
