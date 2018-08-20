//
//  JournalDetailView.swift
//  EmojiDaily3
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import Foundation
import UIKit

class JournalDetailViewController : UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate, TagArrayUpdateDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var disposeButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    
    // Toolbar Group
    @IBOutlet var undoButton: UIBarButtonItem!
    @IBOutlet var redoButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var flexibleSpace: UIBarButtonItem!
    @IBOutlet var tagButton: UIBarButtonItem!
    
    var placeHolder = "✏️📖"
    var journal : Journal! = nil
    var chapter : Chapter!
    var tags : [Tag] {
        get {
            if (_tags == nil) {
                _tags = []
                if let journalTags = journal?.tag?.allObjects {
                    for tag in journalTags {
                        let objTag = tag as! Tag
                        _tags.append(objTag)
                    }
                }
            }
            return _tags
        }
        set {
            _tags = newValue
        }
    }
    
    private var _tags : [Tag]! = nil
    private var isEditingMode : Bool = false
    private var isNewJournal : Bool = false
    
    override func viewDidLoad() {
        textView.delegate = self
        if (journal == nil) {
            navigationItem.leftBarButtonItem = disposeButton
            navigationItem.rightBarButtonItem = doneButton
            textView.alpha = 0.4
            textView.text = placeHolder
            enterEditMode()
            isNewJournal = true
        } else {
            navigationItem.rightBarButtonItem = editButton
            titleTextField.text = journal.title
            textView.text = journal.content
            exitEditMode()
            isNewJournal = false
        }
        tagButton.setIcon(icon: .fontAwesomeSolid(.tag), iconSize: 18, color: toolbar.tintColor)
        navigationItem.titleView = titleTextField
        NotificationCenter.default.addObserver(self, selector: #selector(adjustSafeArea(note:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.selectAll(nil)
        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func done(_ sender: Any) {
        if (titleTextField.text?.isEmpty ?? true) {
            highlightTextField(UIColor.red)
            return
        }
        
        updateOrCreateJournal()
        if (isNewJournal) {
            for tag in tags {
                tag.addToJournal(journal)
            }
            performSegue(withIdentifier: "unwindToJournalSegue", sender: sender)
        } else {
            exitEditMode()
        }
        JournalServices.shared.saveContext()
    }
    
    @IBAction func backAndDispose(_ sender: Any) {
        if let disposingJournal = journal {
            JournalServices.shared.deleteJournal(journal: disposingJournal)
        }
        
        for tag in tags {
            if (journal != nil) {
                tag.removeFromJournal(journal)
            }
            if tag.journal?.count ?? 0 == 0 {
                JournalServices.shared.deleteTag(tag: tag)
            }
        }
        JournalServices.shared.saveContext()
        performSegue(withIdentifier: "unwindToJournalSegue", sender: sender)
    }

    @IBAction func edit(_ sender: Any) {
        enterEditMode()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.alpha < 1 {
            textView.text = nil
            textView.alpha = 1
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.alpha = 0.4
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUndoButtons()
    }
    
    func updateOrCreateJournal() {
        if journal == nil{
            journal = JournalServices.shared.newJournal(chapter: chapter, title: titleTextField.text!, content: textView.text)
        } else {
            journal.title = (titleTextField.text) ?? ""
            journal.content = (textView.text) ?? ""
            journal.date = Date()
        }
    }
    
    func enterEditMode() {
        isEditingMode = false
        titleTextField.isEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        
        highlightTextField(view.tintColor)

        if (!isNewJournal) {
            navigationItem.setRightBarButton(doneButton, animated: true)
            navigationItem.setLeftBarButton(disposeButton, animated: true)
            textView.becomeFirstResponder()
        }
        toolbar.setItems([undoButton,flexibleSpace,redoButton,flexibleSpace,tagButton], animated: true)
    }
    
    func exitEditMode() {
        isEditingMode = false
        titleTextField.isEnabled = false
        titleTextField.borderStyle = UITextBorderStyle.none
        textView.isEditable = false
        textView.isSelectable = false
        
        highlightTextField(UIColor.clear)
        
        if (!isNewJournal) {
            navigationItem.setRightBarButton(editButton, animated: true)
            navigationItem.setLeftBarButton(nil, animated: true)
            if (textView.alpha < 1) {
                textView.text = nil
                textView.alpha = 1
            }
        }
        toolbar.setItems([flexibleSpace, tagButton], animated: true)
    }
    
    func highlightTextField(_ color: UIColor) {
        titleTextField.layer.borderColor = color.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.cornerRadius = 5
        titleTextField.alpha = 0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        titleTextField.alpha = 1
        UIView.commitAnimations()
    }
    
    @IBAction func redo(_ sender: Any) {
        textView.undoManager?.redo()
        updateUndoButtons()
    }
    @IBAction func undo(_ sender: Any) {
        textView.undoManager?.undo()
        updateUndoButtons()
    }
    
    func updateUndoButtons() {
        undoButton.isEnabled = textView.undoManager?.canUndo ?? false
        redoButton.isEnabled = textView.undoManager?.canRedo ?? false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tagListPopoverSegue") {
            if let destination = segue.destination as? TagListViewController {
                destination.popoverPresentationController?.delegate = self
                
                destination.journal = journal
                destination.tags = self.tags
                destination.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func updateTags(newTags: [Tag]) {
        tags = newTags
    }
}
