//
//  SizeExample.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/3/9.
//

import CoreData
import Flow
import SwiftUI

struct ColorExample: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) private var presentationMode
  @Binding var selectedColors: [String]
  //  @Binding var sheetSelected: Bool
  
  //  @State private var selectedColors = [String]()
  
  @State private var phase = 0.0
  @State private var showingAlert = false
  @State private var deleteAlert = false
  @State private var isSelectedColor = false
  @State private var name = ""
  @State private var deleteIndex: Int?
  @State private var colors333: [String] = []
  //  @State private var isSelectionColor: Bool = false
  // 创建一个空数组，然后把name里的值保存到空数组里面
  @State private var colors222: [Sku] = []
  
  @State private var isAppFirstLaunch: Bool = true
  
  @FetchRequest(
    entity: Sku.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Sku.createdAt, ascending: true)],
//    predicate: NSPredicate(format: "colorArray != nil AND colorArray != ''"),
    animation: .default
  ) var colors: FetchedResults<Sku>
  
  @FetchRequest(
    entity: Sku.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Sku.createdAt, ascending: true)],
    animation: .default
  )
  private var colorsFetchRequest: FetchedResults<Sku>
  
  private func submit() {
    // 判断输入是否为空或已存在
    guard !name.isEmpty, !colors222.contains(where: { $0.colorArray!.contains(name) == true }) else {
      showingAlert = true
      return
    }
    
    // 添加进来
    let newColor = Sku(context: viewContext)
    newColor.colorArray = [name]
    colors222.append(newColor)
    
    do {
      try viewContext.save()
    } catch {
      print("Error saving color: \(error.localizedDescription)")
    }
    // 清空
    name = ""
    //    newColor.isSelected = false
    print("You entered \(name)")
    print("You entered \(colors)")
  }
  
  var body: some View {
    ZStack {
      Color(.white).ignoresSafeArea()
      VStack(spacing: 0) {
        Color.clear.overlay {
          header()
        }
        .frame(height: 70)
        
        Color.clear.overlay {
          content()
            .frame(maxHeight: .infinity, alignment: .top)
        }
        
        Color.clear.overlay {
          bottom()
        }
        .frame(height: 40)
      }
    }
  }
  
  @ViewBuilder
  private func header() -> some View {
    HStack(spacing: 0) {
      Color.clear.overlay {
        Text("选择颜色")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      Color.clear.overlay {
        Text("长按删除")
          .foregroundColor(.black)
          .opacity(0.6)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }.padding()
    //      .frame(height: 70)
  }
  
  @State private var colorsSelected: Set<String> = []
  @State private var longPressIndex: Int?
  // 在ForEach中添加一个绑定状态变量用于跟踪删除选项
  @State private var deletingIndex: Int?
  
  private func deleteColor(at index: Int) {
    let color = colors[index]
    guard let sizeToDelete = color.colorArray!.first else { return }
    if color.colorArray!.count == 1 {
      viewContext.delete(color)
    } else {
      // 如果该颜色不止一个尺码，仅删除该尺码
      color.removeFromColorArray(sizeToDelete)
    }
    do {
      try viewContext.save()
    } catch {
      print("Error saving context: \(error.localizedDescription)")
    }
  }

//  private func deleteColor(at index: Int) {
//    if let sizeToDelete = colors[index].colorArray.first {
//      let color = colors.first(where: { $0.colorArray.contains(sizeToDelete) == true })!
//      viewContext.delete(color)
//      do {
//        try viewContext.save()
//      } catch {
//        print("Error saving context: \(error.localizedDescription)")
//      }
//    }
//  }
  
  @ViewBuilder
  private func content() -> some View {
    HFlow(itemSpacing: 10, rowSpacing: 10) {
      // 按字母顺序对唯一颜色进行排序
      let uniqueColors = Array(Set(colors.flatMap { $0.colorArray ?? [] })).sorted()
      ForEach(uniqueColors, id: \.self) { size in
        Text(size)
          .foregroundColor(.black)
          .padding()
          .frame(height: 30)
          .contentShape(Rectangle())
          .overlay(
            ZStack(alignment: .bottomTrailing) {
              GeometryReader { geometry in
                Color.clear
                  .preference(key: TextExWidthKey.self, value: geometry.size.width)
              }
                  
              if selectedColors.contains(size) {
                ZStack {
                  // 打勾时，出现红色圆圈
                  Circle()
                    .foregroundColor(.orange)
                    .frame(height: 10)

                  // 让image出现在红色圆圈上面
                  Image(systemName: "checkmark")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 8, height: 6)

                }.offset(x: 0, y: 0)
              } else {
                //                Image(systemName: "square")
                //                  .foregroundColor(.black)
              }
                  
              //              Text(color.colors)
              //                .foregroundColor(.black)
                  
              RoundedRectangle(cornerRadius: 4)
                  
                .strokeBorder(selectedColors.contains(size) ? Color.red : Color.black, style: StrokeStyle(lineWidth: 1))
                .opacity(0.5)
            }
          )
          // 把选中的勾宽度随着文字宽度放在右下角
            
          .contentShape(Rectangle())
            
          .onAppear {
            // 清空选中的状态
            print("content：生命周期初始化")
            //            selectedColors.removeAll()
          }
          .onTapGesture {
            // 如果已经被选择，则从selectedColors数组中删除它；否则，将其添加到数组中
            if selectedColors.contains(size) {
              selectedColors.removeAll(where: { $0 == size })

              //              color.isSelected = false
            } else {
              selectedColors.append(size)
              //              color.isSelected = true
            }
            do {
              try viewContext.save()
            } catch {
              print("Error saving color: \(error.localizedDescription)")
            }
          }
            
          //         长按弹出提示删除框
          .onLongPressGesture {
//            if let color = colors.first(where: { $0.colorArray.contains(size) == true }) {
//              deleteIndex = colors.firstIndex(of: color)
//              deleteAlert = true
//            }
            if let index = colors.firstIndex(where: { $0.colorArray!.contains(size) }) {
                deleteIndex = index
                deleteAlert = true
              }
          }
            
          .alert(isPresented: $deleteAlert) {
            let sizeToDelete = colors[deleteIndex!].colorArray!.first!
            return Alert(
              title: Text("确定要删除 \(sizeToDelete) 颜色吗？"),
              primaryButton: .destructive(Text("删除"), action: {
                // 调用删除操作函数来删除选定的颜色
                deleteColor(at: deleteIndex!)
              }),
              secondaryButton: .cancel(Text("取消"))
            )
          }
      }
 
      Text("新增颜色")
        .foregroundColor(Color.red)
        // 给文字添加红色外框
        .overlay(
          RoundedRectangle(cornerRadius: 4)
          
            .strokeBorder(Color.red, style: StrokeStyle(lineWidth: 1, dash: [4], dashPhase: phase))
            .frame(width: 80, height: 30)
          
            .onAppear {
              withAnimation(.linear.repeatForever(autoreverses: false)) {
                phase -= 10
              }
            }
        )
        .contentShape(Rectangle())
      
        .onTapGesture {
          showingAlert = true
        }
        .alert("新增颜色", isPresented: $showingAlert) {
          TextField("请输入颜色", text: $name)
          Button("确定", action: submit)
        }
    }
    .padding(8)
    
    //    .frame(maxWidth: 300)
  }
  
  @ViewBuilder
  private func bottom() -> some View {
    VStack {
      Divider()
      
      HStack {
        Text("已选择：\(selectedColors.count)")
        Spacer()
        Button("保存") {
          print("已选择的颜色：\(selectedColors)")
          
          presentationMode.wrappedValue.dismiss()
        }
      }.padding()
    }
  }
}

// struct TextExWidthKey: PreferenceKey {
//  static var defaultValue: CGFloat = 0
//
//  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//    value = max(value, nextValue())
//  }
// }

// struct SizeViewClothes_Previews: PreviewProvider {
//    static var previews: some View {
//        SizeViewClothes()
//    }
// }
