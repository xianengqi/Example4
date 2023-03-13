import CoreData
import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Spu.name, ascending: true)],
    animation: .default
  )
  private var spus: FetchedResults<Spu>

  @State private var showAddSpuSheet = false

  var body: some View {
    NavigationView {
      List {
        ForEach(spus) { spu in
          NavigationLink(destination: SpuDetail(spu: spu)) {
            Text(spu.name ?? "")
          }
        }

        Button(action: {
          showAddSpuSheet = true
        }) {
          Label("添加商品", systemImage: "plus")
        }
        .sheet(isPresented: $showAddSpuSheet) {
          AddSpuSheet()
            .environment(\.managedObjectContext, viewContext)
        }
      }
      .navigationTitle("商品库存")
      .toolbar {
        EditButton()
      }
    }
  }
}

struct AddSpuSheet: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) private var presentationMode

  @State private var name = ""

  var body: some View {
    NavigationView {
      Form {
        TextField("名称", text: $name)
      }
      .navigationTitle("添加商品")
      .navigationBarItems(
        leading: Button("取消") {
          presentationMode.wrappedValue.dismiss()
        },
        trailing: Button("保存") {
          let newSpu = Spu(context: viewContext)
          newSpu.name = name

          try? viewContext.save()
          presentationMode.wrappedValue.dismiss()
        }
        .disabled(name.isEmpty)
      )
    }
  }
}
