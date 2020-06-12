import Foundation
import UIKit
import ARKit

class ScanRecorderViewController: UIViewController {
        
    private var scanRecorder: ScanRecorder!
    private var scanRecorderView: ScanRecorderView!
    private var coachingViewController: CoachingViewController!
    private var objectSelectorViewController: ObjectSelectorViewController!
    private var minimapViewController: MinimapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanRecorder = ScanRecorder()
        self.scanRecorder.delegate = self
        
        self.scanRecorderView = ScanRecorderView()
        self.view = self.scanRecorderView
        self.scanRecorderView.recordButton.addTarget(self, action: #selector(self.recordButtonDidTouchUpInside(_:)), for: .touchUpInside)
        
        self.scanRecorder.arViewProvider = self.scanRecorderView
        
        self.coachingViewController = CoachingViewController()
        self.addChild(self.coachingViewController)
        self.scanRecorderView.setCoachingView(self.coachingViewController.view as! CoachingView)
        self.coachingViewController.hide(animate: false)
        
        self.objectSelectorViewController = ObjectSelectorViewController()
        self.addChild(self.objectSelectorViewController)
        self.scanRecorderView.setObjectSelectorView(self.objectSelectorViewController.view as! ObjectSelectorView)
        
        self.minimapViewController = MinimapViewController()
        self.addChild(self.minimapViewController)
        self.scanRecorderView.setMinimapView(self.minimapViewController.view as! MinimapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.scanRecorder.startSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.coachingViewController.showMessage("Hold the device vertically and perpendicular to a wall before beginning.", animate: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.parent?.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @objc private func recordButtonDidTouchUpInside(_ sender: UIButton) {
        if self.scanRecorder.isRecording {
            sender.setTitle("RECORD", for: .normal)
            self.scanRecorder.stopRecording()
        } else {
            sender.setTitle("SAVE", for: .normal)
            self.scanRecorder.startRecording()
        }
    }
}

extension ScanRecorderViewController: ScanRecorderDelegate {
    func didUpdateScanState(_ state: ScanState) {
        self.minimapViewController.update(from: state)
    }
}
