//
//  Category+CoreDataClass.swift
//  Assignment6
//


import Foundation
import CoreData


public class Category: NSManagedObject {
	var subtitle: String {
		let count = images?.count ?? 0
		return "Contains \(count) images"
	}
}
