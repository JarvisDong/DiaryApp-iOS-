//
//  TagListViewController.swift
//  EmojiDaily3
//
//  Created by Haojun Dong on 8/17/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import CoreData
import UIKit

protocol TagArrayUpdateDelegate {
    func updateTags(newTags: [Tag])
}

class TagListViewController : UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, TagListViewDelegate, TagListViewDataDelegate {
    
    @IBOutlet weak var tagList: TagListViewWithTextField!
    @IBOutlet weak var tableView: UITableView!
    
    var journal : Journal! = nil
    var tags : [Tag]! = nil
    var delegate : TagArrayUpdateDelegate?
    
    private var resultsController : NSFetchedResultsController<Tag>?
    private var isPopulatingTagList = false
    
    override func viewDidLoad() {
        tagList.delegate = self
        tagList.dataDelegate = self
        tagList.textFont = UIFont.systemFont(ofSize: 16)
        tableView.delegate = self
        tableView.dataSource = self
        resultsController = JournalServices.shared.tags()
        resultsController?.delegate = self
        tableView.tableFooterView = UIView()
        
        if (tags == nil) {
            return
        }
        
        for tag in tags {
            tagList.addTag(tag.tagname!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (tags == nil) {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tagCell")!
        tableViewCell.textLabel?.text = resultsController?.object(at: indexPath).tagname
        return tableViewCell
    }
    
    
    func tagShouldBeAdded(_ title: String, reason: TagListReason, sender: TagListView) -> Bool {
        if reason == .byUser {
            if tags.contains(where: { tag in return tag.tagname == title }) {
                return false
            }
        }
        return true
    }
    
    func tagAddedOrInserted(_ title: String, reason: TagListReason, tagView: TagView, sender: TagListView) {
        if reason == .byUser {
            let tag = JournalServices.shared.tag(withName: title)
            if (journal != nil) { tag.addToJournal(journal) }
            tags.append(tag)
            JournalServices.shared.updatePredicate(toRemoveFromController: resultsController as! NSFetchedResultsController<NSManagedObject>)
            tableView.reloadSections([0], with: .automatic)
        }
    }
    
    func tagWillBeRemoved(_ title: String, sender: TagListView) {
        if let index = tags.index(where: { tag in return tag.tagname! == title}) {
            let removedTag = tags.remove(at: index)
            if (journal != nil) { removedTag.removeFromJournal(journal) }
            if (removedTag.journal?.count == 0) {
                JournalServices.shared.deleteTag(tag: removedTag)
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (tableView.isEditing) {
            return
        }
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .automatic)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
            }
        case .update:
            if let updateIndexPath = indexPath, let tableViewCell = tableView.cellForRow(at: updateIndexPath) {
                tableViewCell.textLabel?.text = resultsController?.object(at: updateIndexPath).tagname
            }
        case .move:
            if let sourceIndexPath = indexPath, let destinationIndexPath = newIndexPath {
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = resultsController?.object(at: indexPath) {
            if !tags.contains(tag) {
                tags.append(tag)
                if (journal != nil) { tag.addToJournal(journal) }
                tagList.addTag(tag.tagname!)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            JournalServices.shared.updatePredicate(toRemoveFromController: resultsController as! NSFetchedResultsController<NSManagedObject>)
        } else {
            let searchPredicate = NSPredicate(format: "tagname contains %@", textField.text!)
            JournalServices.shared.updatePredicate(searchPredicate, toUpdateController: resultsController as! NSFetchedResultsController<NSManagedObject>)
        }
        tableView.reloadSections([0], with: .automatic)
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagList.removeTagView(tagView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateTags(newTags: tags)
        super.viewWillDisappear(animated)
        JournalServices.shared.saveContext()
    }
}
