//
//  Category+CoreDataClass.swift
//  Assignment5
//
//  Created by Haojun Dong on 7/30/18.
//
//

import Foundation
import CoreData


public class Category: NSManagedObject {
    var subtitle: String {
        get {
            return "Contains \(images!.count) items"
        }
    }
}
