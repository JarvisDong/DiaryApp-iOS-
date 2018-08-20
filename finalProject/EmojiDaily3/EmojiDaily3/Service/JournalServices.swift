//
//  JournalServices.swift
//  EmojiDaily2
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import Foundation
import CoreData

class JournalServices {
    static let shared = JournalServices()
    private let persistentContainer : NSPersistentContainer
    private var cachedChapterResultsController : NSFetchedResultsController<Chapter>?
    private var cachedPredicate : Dictionary<NSFetchedResultsController<NSManagedObject>, NSPredicate?>
    
    private init() {
        cachedPredicate = Dictionary<NSFetchedResultsController<NSManagedObject>, NSPredicate>()
        persistentContainer = NSPersistentContainer(name: "EmojiDaily")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print("loaded")
        })
        cachedChapterResultsController = nil
    }
    
    private func fetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> where T: NSManagedObject {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        context.perform {
            try! context.save()
        }
    }
    
    // Chapters
    func chapters() -> NSFetchedResultsController<Chapter> {
        if cachedChapterResultsController != nil {
            return cachedChapterResultsController!
        } else {
            let fetchRequest: NSFetchRequest<Chapter> = Chapter.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "weight", ascending: true), NSSortDescriptor(key: "date", ascending: false)]
            cachedChapterResultsController = fetchedResultsController(for: fetchRequest)
            return cachedChapterResultsController!
        }
    }
    
    @discardableResult
    func newChapter(title: String) -> Chapter {
        let context = persistentContainer.viewContext
        let chaptersResultController = chapters()
        
        let chapter = Chapter(context: context)
        chapter.weight = (chaptersResultController.fetchedObjects?.first?.weight) ?? 0
        chapter.date = Date()
        chapter.title = title
        
        return chapter
    }
    
    func deleteChapter(chapter: Chapter) {
        let context = persistentContainer.viewContext
        context.delete(chapter)
    }
    
    // Journals
    func journals(chapter: Chapter) -> NSFetchedResultsController<Journal> {
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chapter = %@", chapter)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return fetchedResultsController(for: fetchRequest)
    }
    
    @discardableResult
    func newJournal(chapter: Chapter, title: String, content: String) -> Journal {
        let context = persistentContainer.viewContext
        
        let journal = Journal(context: context)
        journal.title = title
        journal.content = content
        journal.date = Date()
        journal.chapter = chapter
        
        return journal
    }
    
    func deleteJournal(journal: Journal) {
        let context = persistentContainer.viewContext
        context.delete(journal)
    }
    
    // Tags
    func tags() -> NSFetchedResultsController<Tag> {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "date", ascending: false)]
        return fetchedResultsController(for: fetchRequest)
    }
    
    func tags(forJournal journal: Journal) -> NSFetchedResultsController<Tag> {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "journal = %@", journal)
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "date", ascending: false)]
        return fetchedResultsController(for: fetchRequest)
    }
    
    @discardableResult
    func newTag(name: String) -> Tag {
        let context = persistentContainer.viewContext
        
        let tag = Tag(context: context)
        tag.tagname = name
        tag.date = Date()
        
        return tag
    }
    
    func tag(withName name: String) -> Tag {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tagname = %@", name)
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "date", ascending: false)]
        if let result = try? context.fetch(fetchRequest), let tag = result.first {
            return tag
        }
        
        let tag = Tag(context: context)
        tag.tagname = name
        tag.date = Date()
        return tag

    }
    
    func deleteTag(tag : Tag) {
        let context = persistentContainer.viewContext
        context.delete(tag)
    }
    
    // Search
    func updatePredicate(_ predicate : NSPredicate, toUpdateController controller: NSFetchedResultsController<NSManagedObject>) {
        if !cachedPredicate.keys.contains(controller) {
            cachedPredicate[controller] = controller.fetchRequest.predicate
        }
        
        if let originalPredicate = cachedPredicate[controller]!{
            controller.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [originalPredicate, predicate])
        } else {
            controller.fetchRequest.predicate = predicate
        }
        try! controller.performFetch()
    }
    
    func updatePredicate(toRemoveFromController controller: NSFetchedResultsController<NSManagedObject>) {
        controller.fetchRequest.predicate = cachedPredicate[controller]!
        cachedPredicate.removeValue(forKey: controller)
        try! controller.performFetch()
    }
    
}
