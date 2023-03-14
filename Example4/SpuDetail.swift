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
          VStack(alignment: .leading) {
//              Text("\(sku.color ?? "") \(sku.size ?? "")")
            Text("\(sku.colorArray.map { "\($0)" }.joined(separator: ", ")) \(sku.sizeArray.map { "\($0)" }.joined(separator: ", "))")

            Text("库存: \(sku.stock)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
//          NavigationLink(destination: SkuDetailView(sku: sku)) {
//            VStack(alignment: .leading) {
////              Text("\(sku.color ?? "") \(sku.size ?? "")")
//              Text("\(sku.colorArray.map { "\($0)" }.joined(separator: ", ")) \(sku.size ?? "")")
//
//              Text("库存: \(sku.stock)")
//                .font(.caption)
//                .foregroundColor(.secondary)
//            }
//          }
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
            .presentationDetents(
              [.medium])
            .presentationBackground(.ultraThinMaterial)
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(20)
            .presentationContentInteraction(.scrolls)
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

  @State private var selectedColors: [String] = []
  @State private var selectedSizes: [String] = []
  @State var showColor = false
  @State var showSize = false
  @State private var isSaved = false
  @State private var linkDetail = false
  @Environment(\.dismiss) private var dismiss

  @State private var color = ""
  @State private var size = ""
  @State private var price = ""
  @State private var stock = ""

  var body: some View {
    NavigationView {
      VStack {
//        TextField("尺码", text: $size)
        VStack(spacing: 10) {
//          TextField("颜色", text: $color)
          formColorView().frame(height: 20)
          
          Divider()
          formSizeView().frame(height: 20)
          Divider()
          TextField("价格", text: $price)
            .keyboardType(.decimalPad)
          Divider()
          TextField("库存", text: $stock)
            .keyboardType(.numberPad)
          Divider()
          Spacer()
        }
        .padding()
        .frame(height: 300)
        .background(Color.white)
        Spacer()
      }
      .navigationTitle("添加SKU")
      .navigationBarItems(
        leading: Button("取消") {
          presentationMode.wrappedValue.dismiss()
        },
        trailing: Button("保存") {
          // 判断输入是否为空或已存在
          if selectedColors.isEmpty || selectedSizes.isEmpty || price.isEmpty || stock.isEmpty {
            return
          }

          
          
          let newSku = Sku(context: viewContext)
//          newSku.color = color
//          newSku.size = size
          newSku.colorArray = selectedColors
          newSku.sizeArray = selectedSizes
          
          newSku.price = Double(price) ?? 0
          newSku.stock = Int16(stock) ?? 0
          newSku.spu = spu
//          newSku.sizes = spu.skus?.compactMap { ($0 as? Sku)?.size } ?? []

          spu.addSku(newSku)

          try? viewContext.save()
//          spu.objectWillChange.send() // force view refresh
          presentationMode.wrappedValue.dismiss()
        }
        .disabled(selectedColors.isEmpty || selectedSizes.isEmpty || price.isEmpty || stock.isEmpty))
    }
  }

  @ViewBuilder
  func formColorView() -> some View {
    HStack {
      Color.clear.overlay {
        Text("颜色")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(width: 40)

      Color.clear.overlay {
        Text(selectedColors.isEmpty ? "选择颜色" : "\(selectedColors.joined(separator: ", "))")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .center)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }.frame(width: 10)
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      print("点击弹出Sheet")
      // 在打开Sheet之前先将已选中的颜色状态清空
      selectedColors = []
      showColor = true
//      let isSelected = selectedColors.contains(color.colors)
//      isSelected = false
      // 清空选中的颜色状态
//      selectedColors.removeAll()
    }

    .sheet(isPresented: $showColor) {
      ColorExample(selectedColors: $selectedColors)
        .onAppear {
          // 清空选中的颜色状态

          selectedColors.removeAll()
          // 把 isSelected状态设置为flase
        }
//        .environment(\.managedObjectContext, viewContext)
        .presentationDetents(
          [.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
        .presentationContentInteraction(.scrolls)
    }

    
  }

  @ViewBuilder
  func formSizeView() -> some View {
    HStack {
      Color.clear.overlay {
        Text("尺码")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }.frame(width: 40)

      Color.clear.overlay {
        Text(selectedSizes.isEmpty ? "选择尺码" : "\(selectedSizes.joined(separator: ", "))")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .center)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }.frame(width: 10)
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      showSize = true
    }

    .sheet(isPresented: $showSize) {
      SizeExample(selectedColors: $selectedSizes)
        .onAppear {
          // 清空选中的颜色状态

          selectedSizes.removeAll()
          // 把 isSelected状态设置为flase
        }
        .presentationDetents(
          [.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
        .presentationContentInteraction(.scrolls)
    }
  }
}
