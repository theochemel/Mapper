import Foundation

protocol ScanRecorderDelegate: class {
    func didUpdateScanState(_ state: ScanState)
    func didFinishScan(_ rawScan: RawScan)
}
