//
//  CatService.swift
//  Assignment5
//


import CoreData
import Foundation


class CatService {
	// MARK: Service
    
	func catCategories() -> NSFetchedResultsController<Category>? {

        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        var fetchedResultsController: NSFetchedResultsController<Category>? = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        }
        catch {
            fetchedResultsController = nil
        }
        
        return fetchedResultsController
	}

    
    func images(for index: Category) -> NSFetchedResultsController<Image>? {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", index)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
        var fetchedResultsController: NSFetchedResultsController<Image>? = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        }
        catch {
            fetchedResultsController = nil
        }
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

			// TODO: Store the cat data in CoreData if it is not already present
            guard error == nil else {
                fatalError("Could not create store")
            }
            
            let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
            let context = self.persistentContainer.newBackgroundContext()
            context.performAndWait {
                guard let count = try? context.count(for: fetchRequest), count == 0 else {
                    return
                }
                
                for catvalue in catValues {
                    let cat = Category(context: context)
                    let name = catvalue[self.titleKey] as! String
                    cat.title = name
                    
                    let CatImageValues = catvalue[self.imageNamesKey] as! Array<String>
                    for someCatValue in CatImageValues.enumerated() {
                        let picture = Image(context: context)
                        picture.imagename = someCatValue.element
                        picture.value = Int32(someCatValue.offset)
                        picture.category = cat
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
