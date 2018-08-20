//
//  ChapterViewController.swift
//  EmojiDaily2
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import CoreData
import UIKit

class ChapterListViewController : UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {
    private var resultsController : NSFetchedResultsController<Chapter>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        resultsController = JournalServices.shared.chapters()
        resultsController?.delegate = self
        
        navigationItem.setLeftBarButton(editButton, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustSafeArea(note:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func fillCell(_ cell : UITableViewCell, _ indexPath: IndexPath) {
        let chapter = resultsController?.object(at: indexPath)
        cell.textLabel?.text = chapter?.title ?? "undefined"
        cell.detailTextLabel?.text = "\(chapter?.journal?.count ?? 0)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "chapterCell")
        fillCell(tableViewCell!, indexPath)
        return tableViewCell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Rename", handler: { (_, indexPath) in
            tableView.tableFooterView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.width, height:tableView.frame.height))
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.performSegue(withIdentifier: "renamePopoverSegue", sender: self.resultsController?.object(at: indexPath))
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (_, indexPath) in
            if let chapter = self.resultsController?.object(at: indexPath) {
                JournalServices.shared.deleteChapter(chapter: chapter)
                JournalServices.shared.saveContext()
                try! self.resultsController?.performFetch()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        })
        return [deleteAction, editAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "titlePopoverSegue" {
            if let destination = segue.destination as? ChapterNamePopoverViewController {
                destination.popoverPresentationController?.delegate = self
            }
        } else if segue.identifier == "showChapterSegue" {
            if let destination = segue.destination as? JournalListViewController {
                let indexPath = (tableView.indexPathForSelectedRow)!
                destination.chapter = resultsController?.object(at: indexPath)
            }
        } else if segue.identifier == "renamePopoverSegue" {
            if let destination = segue.destination as? ChapterNamePopoverViewController {
                destination.popoverPresentationController?.delegate = self
                // anchor to one cell below navigation bar
                destination.popoverPresentationController?.sourceView = navigationController?.navigationBar
                let frame = (navigationController?.navigationBar.bounds)!
                let anchorFrame = CGRect(x: frame.origin.x, y: frame.origin.y + 44, width: frame.size.width, height: frame.size.height)
                destination.popoverPresentationController?.sourceRect = anchorFrame
                
                if let chapter = sender as? Chapter {
                    destination.renamingChapter = chapter
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.row
        let destinationIndex = destinationIndexPath.row
        
        var chapters = resultsController?.fetchedObjects ?? []
        
        let removed = chapters.remove(at: sourceIndex)
        chapters.insert(removed, at: destinationIndex)
        
        for i in 0..<chapters.count {
            chapters[i].weight = Int32(i)
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        editButton.isEnabled = false;
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        editButton.isEnabled = true;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            JournalServices.shared.deleteChapter(chapter: (resultsController?.object(at: indexPath))!)
            JournalServices.shared.saveContext()
            try! resultsController?.performFetch()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func enterEditMode(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        navigationItem.setLeftBarButton(doneButton, animated: true)
        addButton.isEnabled = false
    }
    
    @IBAction func exitEditMode(_ sender: Any) {
        JournalServices.shared.saveContext()
        tableView.setEditing(false, animated: true)
        navigationItem.setLeftBarButton(editButton, animated: true)
        addButton.isEnabled = true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tableView.tableFooterView = UIView()
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
        case .update, .move:
            if let updateIndexPath = indexPath {
                fillCell(tableView.cellForRow(at: updateIndexPath)!, updateIndexPath)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
}
