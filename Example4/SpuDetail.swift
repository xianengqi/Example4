import CoreData
import SwiftUI

struct SpuDetail: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var spu: Spu
  @State private var spuStock: Int16 = 0

  @State private var showAddSkuSheet = false

  var body: some View {
    List {
      Section(header: Text("商品信息")) {
        HStack {
          Text("名称")
          Spacer()
          Text(spu.name ?? "")
        }
      }

      Section(header: Text("商品SKU")) {
        ForEach(spu.skus?.allObjects as? [Sku] ?? []) { sku in
          NavigationLink(destination: SkuDetailView(sku: sku)) {
            VStack(alignment: .leading) {
              Text("\(sku.color ?? "") \(sku.size ?? "")")
              Text("库存哈: \(sku.stock)")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
        }

        Button(action: {
          showAddSkuSheet = true
        }) {
          HStack {
            Image(systemName: "plus.circle.fill")
            Text("添加SKU")
          }
        }
        .sheet(isPresented: $showAddSkuSheet) {
          AddSkuSheet(spu: spu)
            .environment(\.managedObjectContext, viewContext)
        }
      }
    }
//    .onDisappear {
//      try? viewContext.save()
//    }
    .navigationTitle(spu.name ?? "")
    .onAppear {
      spu.objectWillChange.send()
    }
  }
}

struct AddSkuSheet: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) private var presentationMode

  @ObservedObject var spu: Spu

  @State private var color = ""
  @State private var size = ""
  @State private var price = ""
  @State private var stock = ""

  var body: some View {
    NavigationView {
      Form {
        TextField("颜色", text: $color)
        TextField("尺码", text: $size)
        TextField("价格", text: $price)
          .keyboardType(.decimalPad)
        TextField("库存", text: $stock)
          .keyboardType(.numberPad)
      }
      .navigationTitle("添加SKU")
      .navigationBarItems(
        leading: Button("取消") {
          presentationMode.wrappedValue.dismiss()
        },
        trailing: Button("保存") {
          let newSku = Sku(context: viewContext)
          newSku.color = color
          newSku.size = size
          newSku.price = Double(price) ?? 0
          newSku.stock = Int16(stock) ?? 0
          newSku.spu = spu
          newSku.sizes = spu.skus?.compactMap { ($0 as? Sku)?.size } ?? []

          spu.addSku(newSku)

          try? viewContext.save()
//          spu.objectWillChange.send() // force view refresh
          presentationMode.wrappedValue.dismiss()
        }
        .disabled(color.isEmpty || size.isEmpty || price.isEmpty || stock.isEmpty)
      )
    }
  }
}
