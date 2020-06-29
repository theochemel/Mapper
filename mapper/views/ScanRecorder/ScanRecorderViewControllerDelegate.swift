import Foundation

protocol ScanRecorderViewControllerDelegate {
    func didFinishScanning(rawFloorplan: RawFloorplan, pointCloud: PointCloud?)
}
