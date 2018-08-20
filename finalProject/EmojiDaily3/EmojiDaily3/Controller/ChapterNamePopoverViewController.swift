//
//  ChapterNamePopoverViewController.swift
//  EmojiDaily3
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import Foundation
import UIKit

class ChapterNamePopoverViewController : UIViewController {
    
    var renamingChapter : Chapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //titleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (animated) {
            popoverPresentationController?.containerView?.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (animated) {
            UIView.beginAnimations(nil, context: nil)
            popoverPresentationController?.containerView?.alpha = 1
            UIView.commitAnimations()
            titleTextField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        titleTextField.resignFirstResponder()
    }

    @IBAction func save(_ sender: Any) {
        if (titleTextField.text?.isEmpty ?? true) {
            highlightTextField()
            return
        }
        if let chapter = renamingChapter {
            chapter.title = titleTextField.text ?? ""
        }
        else {
            JournalServices.shared.newChapter(title: titleTextField.text ?? "")
        }
        JournalServices.shared.saveContext()
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBOutlet weak var titleTextField: UITextField!
    
    func highlightTextField() {
        titleTextField.layer.borderColor = UIColor.red.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.cornerRadius = 5
        titleTextField.alpha = 0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        titleTextField.alpha = 1
        UIView.commitAnimations()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let popoverController = popoverPresentationController {
            popoverController.delegate?.popoverPresentationControllerDidDismissPopover?(popoverController)

        }
        super.dismiss(animated: flag, completion: completion)
    }
}
