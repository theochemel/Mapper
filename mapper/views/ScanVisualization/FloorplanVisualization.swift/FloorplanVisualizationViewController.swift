import Foundation
import UIKit

class FloorplanVisualizationViewController: UIViewController, UIScrollViewDelegate {
    
    public var floorplan: Floorplan!
    public var floorplanVisualizationView: FloorplanVisualizationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floorplanVisualizationView = FloorplanVisualizationView()
        self.floorplanVisualizationView.scrollView.delegate = self
        self.view = self.floorplanVisualizationView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.floorplanVisualizationView.draw(floorplan: self.floorplan)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // from https://stackoverflow.com/a/36170800
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}
