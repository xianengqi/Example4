//
//  Spu+CoreDataProperties.swift
//  Example4
//
//  Created by 夏能啟 on 2023/3/13.
//
//

import CoreData
import Foundation

public extension Spu {
  @nonobjc class func fetchRequest() -> NSFetchRequest<Spu> {
    return NSFetchRequest<Spu>(entityName: "Spu")
  }

  @NSManaged var name: String?
  @NSManaged var skus: NSSet?
}

// MARK: Generated accessors for skus

public extension Spu {
  @objc(addSkusObject:)
  @NSManaged func addToSkus(_ value: Sku)

  @objc(removeSkusObject:)
  @NSManaged func removeFromSkus(_ value: Sku)

  @objc(addSkus:)
  @NSManaged func addToSkus(_ values: NSSet)

  @objc(removeSkus:)
  @NSManaged func removeFromSkus(_ values: NSSet)
}

extension Spu: Identifiable {}

extension Spu {
  func addSku(_ sku: Sku) {
    let existingSkus = mutableSetValue(forKey: "skus")
    existingSkus.add(sku)
  }

  func calculateStock() -> Int16 {
    var totalStock: Int16 = 0
    if let skus = skus?.allObjects as? [Sku] {
      for sku in skus {
        totalStock += sku.stock
      }
    }
    return totalStock
  }
  
  

 
}
