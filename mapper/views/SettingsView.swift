import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var backendURL: String = ""
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    self.save()
                }) {
                    Text("Save")
                }
            }
            .padding()
            Text("Settings")
                .font(.largeTitle)
            Form {
                TextField("Backend URL", text: self.$backendURL)
            }
        }
    }
    
    private func save() {
        
    }
}
