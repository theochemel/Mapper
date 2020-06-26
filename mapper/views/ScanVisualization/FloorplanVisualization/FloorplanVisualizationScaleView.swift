import Foundation
import UIKit

class FloorplanVisualizationScaleView: UIView {
    
    private var bracketView: UIView!
    private var scaleLabel: UILabel!
    
    public init() {
        super.init(frame: .zero)

        self.bracketView = FloorplanVisualizationBracketView()
        self.addSubview(bracketView)
        self.layoutBracketView()
        
        self.scaleLabel = {
            let label = UILabel()
            label.text = "1 Meter"
            return label
        }()
        self.addSubview(scaleLabel)
        self.layoutScaleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutBracketView() {
        self.bracketView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bracketView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bracketView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bracketView.topAnchor.constraint(equalTo: self.topAnchor),
            self.bracketView.heightAnchor.constraint(equalToConstant: 8.0),
        ])
    }
    
    private func layoutScaleLabel() {
        self.scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scaleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.scaleLabel.topAnchor.constraint(equalTo: self.bracketView.bottomAnchor, constant: 4.0),
            self.scaleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
