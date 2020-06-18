import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                }
            }
            .padding()
            Text("Settings")
                .font(.largeTitle)
            Form {
                Text("Backend URL")
                    .fontWeight(.bold)
                TextField("Backend URL", text: self.$userDefaultsManager.backendURL)
            }
        }
    }
}
