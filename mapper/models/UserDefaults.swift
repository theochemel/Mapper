import Foundation
import SwiftUI

class UserDefaultsManager: ObservableObject {
    @Published var backendURL: String = UserDefaults.standard.string(forKey: "backendURL") ?? "" {
        didSet {
            UserDefaults.standard.set(self.backendURL, forKey: "backendURL")
        }
    }
}
