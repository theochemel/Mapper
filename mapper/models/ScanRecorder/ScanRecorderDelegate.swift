import Foundation

protocol ScanRecorderDelegate: class {
    func didUpdateScanState(_ state: ScanState)
    func didFinishScanning(rawFloorplan: RawFloorplan, pointCloud: PointCloud?)
}
