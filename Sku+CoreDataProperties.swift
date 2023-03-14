//
//  Sku+CoreDataProperties.swift
//  Example4
//
//  Created by 夏能啟 on 2023/3/13.
//
//

import CoreData
import Foundation

public extension Sku {
  @nonobjc class func fetchRequest() -> NSFetchRequest<Sku> {
    return NSFetchRequest<Sku>(entityName: "Sku")
  }

  @NSManaged var color: String?
  @NSManaged var price: Double
  @NSManaged var size: String?
  @NSManaged var sizes: [String]
  @NSManaged var colorArray: [String]?
  @NSManaged var sizeArray: [String]?
  @NSManaged var stock: Int16
  @NSManaged var spu: Spu?
  @NSManaged var createdAt: Date

  func removeFromColorArray(_ size: String) {
    if let index = colorArray!.firstIndex(of: size) {
      colorArray!.remove(at: index)
    }
  }

//  internal func addSize(_ size: String) {
//    if sizes == nil {
//      sizes = []
//    }
//
//    if !sizes.contains(size) {
//      sizes.append(size)
//      objectWillChange.send()
//    }
//  }
}

extension Sku: Identifiable {}
