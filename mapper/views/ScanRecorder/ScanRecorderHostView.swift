import Foundation
import SwiftUI
import UIKit

struct ScanRecorderHostView: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @ObservedObject var scan: Scan
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanRecorderHostView>) -> ScanRecorderViewController {
        let scanRecorderViewController = ScanRecorderViewController()
        scanRecorderViewController.context = self.managedObjectContext
        scanRecorderViewController.navigationController?.navigationBar.isHidden = true
        scanRecorderViewController.delegate = context.coordinator
        return scanRecorderViewController
    }
    
    func updateUIViewController(_ uiViewController: ScanRecorderViewController, context: UIViewControllerRepresentableContext<ScanRecorderHostView>) {

    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: ScanRecorderViewControllerDelegate {
        var parent: ScanRecorderHostView
        
        init(_ parent: ScanRecorderHostView) {
            self.parent = parent
        }
        
        func didFinishScanning(rawFloorplan: RawFloorplan, pointCloud: PointCloud?) {
            do {
                self.parent.scan.rawFloorplan = rawFloorplan
                self.parent.scan.pointCloud = pointCloud
                try parent.managedObjectContext.save()
            } catch (let error) {
                fatalError("CoreData save failed: \(error.localizedDescription)")
            }
        }
    }
}
