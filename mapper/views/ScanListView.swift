import Foundation
import SwiftUI

struct ScanListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Scan.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Scan.dateCreated, ascending: true)
        ]
    ) var scans: FetchedResults<Scan>
    
    @State private var isShowingCreateScanView = false
    @State private var isShowingSettingsView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.scans, id: \.self) { scan in
                    NavigationLink(destination: ScanView(scan: scan).navigationBarTitle("", displayMode: .inline)) {
                        ScanListCellView(scan: scan)
                    }
                }.onDelete(perform: self.delete)
            }.navigationBarTitle("Scans")
                .navigationBarItems(leading:
                    Button(action: { self.isShowingSettingsView.toggle() }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                        .padding()
                    }
                    .sheet(isPresented: self.$isShowingSettingsView) {
                        SettingsView()
                    }
                , trailing:
                HStack {
                    Button(action: { self.isShowingCreateScanView.toggle() }) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .padding()
                    }
                    .sheet(isPresented: self.$isShowingCreateScanView) {
                        CreateScanView().environment(\.managedObjectContext, self.managedObjectContext)
                    }
                    EditButton()
                })
            Text("other side??")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let scan = self.scans[index]
            self.managedObjectContext.delete(scan)
        }
        
        do {
            try self.managedObjectContext.save()
        } catch (let error) {
            fatalError("CoreData save failed: \(error.localizedDescription)")
        }
    }
}
