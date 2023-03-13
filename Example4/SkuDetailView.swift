import CoreData
import SwiftUI

struct SkuDetailView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var sku: Sku

  @State private var stock: Int16 = 0 {
    didSet {
      sku.stock = stock
    }
  }

  var body: some View {
    VStack {
      Text(sku.color ?? "" + " " + (sku.size ?? ""))
      Text("库存: \(stock)")
      HStack {
        Button("入库") {
          stock += 1
        }
        .buttonStyle(BorderlessButtonStyle())

        Button("出库") {
          stock = max(stock - 1, 0)
        }
        .buttonStyle(BorderlessButtonStyle())
      }
      .frame(maxWidth: 100)
    }
  
    .onAppear {
      stock = sku.stock
    }

    .onDisappear {
      try? viewContext.save()
    }
  }
}
