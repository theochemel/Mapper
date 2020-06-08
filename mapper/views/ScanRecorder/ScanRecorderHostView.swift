import Foundation
import SwiftUI
import UIKit

struct ScanRecorderHostView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanRecorderHostView>) -> ScanRecorderViewController {
        let scanRecorderViewController = ScanRecorderViewController()
        scanRecorderViewController.navigationController?.navigationBar.isHidden = true
        return scanRecorderViewController
    }
    
    func updateUIViewController(_ uiViewController: ScanRecorderViewController, context: UIViewControllerRepresentableContext<ScanRecorderHostView>) {

    }
}
