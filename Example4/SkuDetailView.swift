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

  @State private var quantityToAdd: String = ""
  @State private var quantityToRemove: String = ""

  var body: some View {
    VStack {
      Text(sku.color ?? "" + " " + (sku.size ?? ""))
      Text("库存: \(stock)")

      HStack {
        TextField("入库", text: $quantityToAdd, onCommit: {
          if let quantity = Int16(quantityToAdd) {
            stock += quantity
            quantityToAdd = ""
          }
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 100)

        TextField("出库", text: $quantityToRemove, onCommit: {
          if let quantity = Int16(quantityToRemove) {
            stock = max(stock - quantity, 0)
            quantityToRemove = ""
          }
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 100)
      }

      HStack {
        Button("入库") {
//          stock += 1
          if let quantity = Int16(quantityToAdd) {
            stock += quantity
            quantityToAdd = ""
          }
        }
        .buttonStyle(BorderlessButtonStyle())

        Button("出库") {
//          stock = max(stock - 1, 0)
          if let quantity = Int16(quantityToRemove) {
            stock = max(stock - quantity, 0)
            quantityToRemove = ""
          }
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
