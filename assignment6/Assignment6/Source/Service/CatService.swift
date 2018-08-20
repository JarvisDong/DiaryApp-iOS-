//
//  CatService.swift
//  Assignment6
//


import CoreData
import Foundation


class CatService {
	// MARK: Service
	func catCategories() -> NSFetchedResultsController<Category> {
		let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

		return fetchedResultsController(for: fetchRequest)
	}

	func images(for category: Category) -> NSFetchedResultsController<Image> {
		let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "category == %@", category)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

		return fetchedResultsController(for: fetchRequest)
	}

	// MARK: Private
	private func fetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> where T: NSManagedObject {
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		try! fetchedResultsController.performFetch()

		return fetchedResultsController
	}

	// MARK: Initialization
	private init() {
		persistentContainer = NSPersistentContainer(name: "Model")

		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
			self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true

			let catValuesDataURL = Bundle.main.url(forResource: "CatValues", withExtension: "plist")!
			let catValuesData = try! Data(contentsOf: catValuesDataURL)
			let catValues = try! PropertyListSerialization.propertyList(from: catValuesData, options: [], format: nil) as! Array<Dictionary<String, Any>>

			let context = self.persistentContainer.newBackgroundContext()
			context.perform {
				let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
				let count = try! context.count(for: fetchRequest)
				guard count == 0 else {
					// Cat data already exists
					return
				}

				for categoryValues in catValues {
					let category = Category(context: context)
					category.title = (categoryValues[self.titleKey] as! String)

					for (orderIndex, name) in (categoryValues[self.imageNamesKey] as! Array<String>).enumerated() {
						let image = Image(context: context)
						image.orderIndex = Int32(orderIndex)
						image.name = name

						image.category = category
					}
				}

				try! context.save()
			}
		})
	}

	// MARK: Private
	private let persistentContainer: NSPersistentContainer

	// MARK: Properties (Private, Constant)
	private let titleKey = "CategoryTitle"
	private let imageNamesKey = "ImageNames"

	// MARK: Properties (Static)
	static let shared = CatService()
}
