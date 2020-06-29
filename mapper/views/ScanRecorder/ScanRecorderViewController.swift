import Foundation
import UIKit
import ARKit
import CoreData

class ScanRecorderViewController: UIViewController {
    
    public var context: NSManagedObjectContext!
        
    private var scanRecorder: ScanRecorder!
    private var scanRecorderView: ScanRecorderView!
    private var coachingViewController: CoachingViewController!
    private var objectSelectorViewController: ObjectSelectorViewController!
    private var minimapViewController: MinimapViewController!
    
    var delegate: ScanRecorderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanRecorder = ScanRecorder(context: self.context,
                                         orientation: UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? UIInterfaceOrientation.unknown,
                                         viewportSize: .zero)
        self.scanRecorder.context = self.context
        self.scanRecorder.delegate = self
        
        self.scanRecorderView = ScanRecorderView()
        self.view = self.scanRecorderView
        self.scanRecorderView.recordButton.addTarget(self, action: #selector(self.recordButtonDidTouchUpInside(_:)), for: .touchUpInside)
        self.scanRecorderView.arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleARViewTap(sender:))))
        
        self.scanRecorder.arViewProvider = self.scanRecorderView
        
        self.coachingViewController = CoachingViewController()
        self.addChild(self.coachingViewController)
        self.scanRecorderView.setCoachingView(self.coachingViewController.view as! CoachingView)
        self.coachingViewController.hide(animate: false)
        
        self.objectSelectorViewController = ObjectSelectorViewController()
        self.addChild(self.objectSelectorViewController)
        self.objectSelectorViewController.delegate = self
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
    
    override func viewDidLayoutSubviews() {
        self.scanRecorder.orientationDidChange(UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? UIInterfaceOrientation.unknown)
        self.scanRecorder.viewportSizeDidChange(self.view.bounds.size)
    }
    
    @objc private func recordButtonDidTouchUpInside(_ sender: UIButton) {
        if self.scanRecorder.isRecording {
            sender.setTitle("RECORD", for: .normal)
            self.scanRecorder.stopRecording()
        } else {
            sender.setTitle("SAVE", for: .normal)
            self.scanRecorder.startRecording()
            self.coachingViewController.hide(animate: true)
        }
    }
    
    @objc private func handleARViewTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.scanRecorder.objectPlacementManager?.addPoint()
        }
    }
}

extension ScanRecorderViewController: ScanRecorderDelegate {
    func didUpdateScanState(_ state: ScanState) {
        self.minimapViewController.update(from: state)
    }
    
    func didFinishScanning(rawFloorplan: RawFloorplan, pointCloud: PointCloud?) {
        self.scanRecorderView.arView.session.pause()
        self.delegate?.didFinishScanning(rawFloorplan: rawFloorplan, pointCloud: pointCloud)
        self.navigationController?.popViewController(animated: true)
    }
}

protocol ObjectSelectorDelegate: class {
    func didSelectObject(withCategory category: Object.Category)
    func didCancel()
}

extension ScanRecorderViewController: ObjectSelectorDelegate {
    func didSelectObject(withCategory category: Object.Category) {
        self.scanRecorder.startPlacement(for: category)
    }
    
    func didCancel() {
        self.scanRecorder.stopPlacement()
    }
}
