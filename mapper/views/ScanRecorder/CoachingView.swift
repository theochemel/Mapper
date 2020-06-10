import Foundation
import UIKit

class CoachingView: UIView {
    
    public var blurView: UIVisualEffectView!
    public var dismissButton: UIButton!
    public var messageLabel: UILabel!
    
    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16.0
        self.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .regular)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(blurView)
        self.layoutBlurView()
        
        self.dismissButton = {
            let button = UIButton(type: .close)
            button.tintColor = .white
            return button
        }()
        self.addSubview(dismissButton)
        self.layoutDismissButton()
        
        self.messageLabel = {
            let label = UILabel(frame: .zero)
            label.textColor = UIColor.white
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            return label
        }()
        self.addSubview(messageLabel)
        self.layoutMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutBlurView() {
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.blurView.topAnchor.constraint(equalTo: self.topAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func layoutDismissButton() {
        self.dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dismissButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.dismissButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 24.0),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
    
    private func layoutMessageLabel() {
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.messageLabel.leadingAnchor.constraint(equalTo: self.dismissButton.trailingAnchor, constant: 16.0),
            self.messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
        ])
    }
}
