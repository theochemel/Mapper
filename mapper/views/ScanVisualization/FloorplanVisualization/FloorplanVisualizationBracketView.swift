import Foundation
import UIKit

class FloorplanVisualizationBracketView: UIView {
    
    private var left: UIView!
    private var right: UIView!
    private var bottom: UIView!
    
    public init() {
        super.init(frame: .zero)
        
        self.bottom = UIView()
        self.bottom.backgroundColor = .black
        self.addSubview(self.bottom)
        self.layoutBottom()
        
        self.left = UIView()
        self.left.backgroundColor = .black
        self.addSubview(self.left)
        self.layoutLeft()
        
        self.right = UIView()
        self.right.backgroundColor = .black
        self.addSubview(self.right)
        self.layoutRight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutBottom() {
        self.bottom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottom.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottom.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottom.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.bottom.heightAnchor.constraint(equalToConstant: 2.0),
        ])
    }
    
    private func layoutLeft() {
        self.left.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.left.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.left.widthAnchor.constraint(equalToConstant: 2.0),
            self.left.topAnchor.constraint(equalTo: self.topAnchor),
            self.left.bottomAnchor.constraint(equalTo: self.bottom.topAnchor),
        ])
    }
    
    private func layoutRight() {
        self.right.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.right.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.right.widthAnchor.constraint(equalToConstant: 2.0),
            self.right.topAnchor.constraint(equalTo: self.topAnchor),
            self.right.bottomAnchor.constraint(equalTo: self.bottom.topAnchor),
        ])
    }
}
