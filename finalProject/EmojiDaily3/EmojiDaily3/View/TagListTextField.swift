//
//  TagListTextField.swift
//  EmojiDaily3
//
//  Created by Haojun Dong on 8/17/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import UIKit

class TagListTextField : UITextField, UITextFieldDelegate {
    private var tagListView : TagListViewWithTextField?
    var isAddButton : Bool
    
    required init?(coder aDecoder: NSCoder) {
        isAddButton = true
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init (frame: CGRect) {
        isAddButton = true
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        leftView = paddingView
        leftViewMode = .whileEditing
        self.delegate = self
        addTarget(self, action: #selector(TagListTextField.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        autocapitalizationType = .none
        autocorrectionType = .no
        smartDashesType = .no
        smartInsertDeleteType = .no
        smartQuotesType = .no
        spellCheckingType = .no
        
        returnKeyType = .next
        
        self.tagListView = nil
    }
    
    func setupForTagListView(tagListView: TagListViewWithTextField) {
        self.tagListView = tagListView
        font = tagListView.textFont
        textAlignment = .center
        text = "+"
        textColor = UIColor.white.withAlphaComponent(0.54)
        frame.origin = tagListView.textFieldOrigin()
        let height = tagListView.intrinsicContentSize.height
        frame.size = CGSize(width: height, height: height)
        layer.cornerRadius = frame.width / 2
    }
    
    func textFieldToInputMode(_ animated: Bool) {
        isAddButton = false
        if let tagList = tagListView {
            if animated {
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.1)
            }
            layer.borderWidth = 1
            layer.borderColor = UIColor.lightGray.cgColor
            layer.cornerRadius = 10
            backgroundColor = UIColor.clear
            let height = tagList.rows == 0 ? tagList.intrinsicContentSize.height : tagList.tagViewHeight
            frame.origin = tagList.textFieldOrigin()
            frame.size = CGSize(width: tagList.textFieldMinWidth, height: height)
            textAlignment = .natural
            textColor = UIColor.black
            text = ""
            if animated { UIView.commitAnimations() }
        }
    }
    
    func textFieldToFakeButton(_ animated: Bool) {
        isAddButton = true
        if let tagList = tagListView {
            if animated {
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.1)
            }
            layer.borderWidth = 1
            layer.borderColor = tagList.borderColor?.cgColor
            backgroundColor = tagList.tagBackgroundColor
            let height = tagList.rows == 0 ? tagList.intrinsicContentSize.height : tagList.tagViewHeight
            frame.origin = tagList.textFieldOrigin()
            frame.size = CGSize(width: height, height: height)
            layer.cornerRadius = frame.width / 2
            textAlignment = .center
            textColor = tagList.removeIconLineColor
            text = "+"
            if animated { UIView.commitAnimations() }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldToInputMode(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldToFakeButton(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let width = textWidth(text)
        if let tagList = tagListView {
            if width > tagList.textFieldMinWidth && frame.origin.x + width < tagList.frame.origin.x + tagList.frame.size.width {
                frame.size.width = width
            } else if width < tagList.textFieldMinWidth {
                frame.size.width = tagList.textFieldMinWidth
            } else {
                frame.size.width = tagList.frame.origin.x + tagList.frame.size.width - frame.origin.x
            }
            tagList.dataDelegate?.textFieldDidChange?(textField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (text?.isEmpty ?? true) {
            resignFirstResponder()
            return true
        }
        
        if let tagList = tagListView {
            tagList.addTagViewByTextField(text!)
        }
        return true
    }
    
    func textWidth(_ text : String?) -> CGFloat {
        if let widthText = text {
            let txtField = UITextField(frame: .zero)
            txtField.font = font
            txtField.text = widthText
            txtField.sizeToFit()
            return txtField.frame.size.width + 10
        }
        return CGFloat(0)
    }

}
