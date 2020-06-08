import Foundation
import SwiftUI

struct CreateScanView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var floor: String = ""
    
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
            
            Text("New Scan")
                .font(.largeTitle)
                .padding()
            
            Form {
                Section {
                    TextField("Name", text: self.$name)
                }
                Section {
                    TextField("Address", text: self.$address)
                    TextField("Floor", text: self.$floor)
                }
            }
            Spacer()
        }
    }
    
    private func save() {
        guard self.name.count > 0, self.address.count > 0, self.floor.count > 0 else { return }
        let scan = Scan(context: self.managedObjectContext)
        scan.name = name
        scan.dateCreated = Date()
        scan.address = address
        scan.floor = floor
        
        do {
            try self.managedObjectContext.save()
        } catch (let error) {
            fatalError("CoreData save failed: \(error.localizedDescription)")
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
}
