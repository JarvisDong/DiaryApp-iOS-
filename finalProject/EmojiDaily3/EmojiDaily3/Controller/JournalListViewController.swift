//
//  JournalViewController.swift
//  EmojiDaily2
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import CoreData
import UIKit

class JournalListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var chapter : Chapter!
    private var resultsController : NSFetchedResultsController<Journal>?
    
    override func viewDidLoad() {
        navigationItem.setRightBarButton(addButton, animated: false)
        tableView.delegate = self
        tableView.dataSource = self
        resultsController = JournalServices.shared.journals(chapter: chapter)
        resultsController?.delegate = self
        navigationItem.title = chapter.title
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(adjustSafeArea(note:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
    }
    
    func fillCell(_ cell : UITableViewCell, _ indexPath: IndexPath) {
        let journal = resultsController?.object(at: indexPath)
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MM-dd yyyy HH:mm:ss")
        
        if let cell = cell as? JournalCellWithTags {
            cell.titleLabel.text = journal?.title
            cell.dateLabel?.text = formatter.string(from: (journal?.date)!)
            cell.tagListView.alignment = .right
            cell.tagListView.textFont = UIFont.systemFont(ofSize: 14)
            cell.titleLabel.invalidateIntrinsicContentSize()
            cell.tagListView.removeAllTags()
            for tag in journal?.tag?.allObjects[0..<(journal?.tag?.count ?? 0)] ?? [] {
                if let tag = tag as? Tag {
                    let tagView = cell.tagListView.addTag(tag.tagname!)
                    if cell.tagListView.rows > 2 {
                        cell.tagListView.removeTagView(tagView)
                        return
                    }
                }
            }
        }
        else {
            cell.textLabel?.text = journal?.title
            cell.detailTextLabel?.text = formatter.string(from: (journal?.date)!)
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "journalCell")!
        fillCell(tableViewCell, indexPath)
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            JournalServices.shared.deleteJournal(journal: (resultsController?.object(at: indexPath))!)
            JournalServices.shared.saveContext()
            try! resultsController?.performFetch()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? JournalDetailViewController {
            if segue.identifier == "newJournalSegue" {
                destination.chapter = chapter
            } else if segue.identifier == "showJournalSegue" {
                let selectedJournal = resultsController?.object(at: tableView.indexPathForSelectedRow!)
                destination.journal = selectedJournal
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
            if let updateIndexPath = indexPath {
                tableView.reloadRows(at: [updateIndexPath], with: .automatic)
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
    
    @IBAction func unwindToJournalList(segue: UIStoryboardSegue) {
        return
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            let predicate = NSPredicate(format: "title contains[cd] %@ OR content contains[cd] %@ OR (SUBQUERY(tag, $tag, $tag.tagname like[cd] %@).@count > 0)", searchText, searchText, searchText)
            JournalServices.shared.updatePredicate(predicate, toUpdateController: resultsController! as! NSFetchedResultsController<NSManagedObject>)
        } else {
            JournalServices.shared.updatePredicate(toRemoveFromController: resultsController! as! NSFetchedResultsController<NSManagedObject>)
        }
        tableView.reloadSections([0], with: .automatic)
    }
}
