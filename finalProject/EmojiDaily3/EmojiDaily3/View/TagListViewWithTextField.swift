//
//  TagListViewExtension.swift
//  EmojiDaily3
//
//  Created by Haojun Dong on 8/17/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import UIKit

@objc public enum TagListReason : Int{
    case byUser, byCode
}

@objc public protocol TagListViewDataDelegate {
    @objc optional func tagShouldBeAdded(_ title: String, reason: TagListReason, sender: TagListView) -> Bool
    @objc optional func tagAddedOrInserted(_ title: String, reason: TagListReason, tagView: TagView, sender: TagListView) -> Void
    @objc optional func tagWillBeRemoved(_ title: String, sender: TagListView) -> Void
    @objc optional func textFieldDidChange(_ textField: UITextField) -> Void
}

class TagListViewWithTextField : TagListView {
    
    private var textField : TagListTextField
    let textFieldMinWidth : CGFloat = 60
    var dataDelegate : TagListViewDataDelegate?
    
    override open dynamic var removeIconLineColor: UIColor{
        didSet {
            if (textField.isAddButton) {
                textField.textColor = removeIconLineColor
            }
            super.removeIconLineColor = removeIconLineColor
        }
    }
    
    override open dynamic var tagBackgroundColor: UIColor {
        didSet {
            if (textField.isAddButton) {
                textField.backgroundColor = tagBackgroundColor
            }
            super.tagBackgroundColor = tagBackgroundColor
        }
    }
    
    override open dynamic var cornerRadius: CGFloat {
        didSet {
            if (!textField.isAddButton) {
                textField.layer.cornerRadius = cornerRadius
            }
            super.cornerRadius = cornerRadius
        }
    }
    override open dynamic var borderWidth: CGFloat {
        didSet {
            textField.layer.borderWidth = borderWidth
            super.borderWidth = borderWidth
        }
    }
    
    override open dynamic var borderColor: UIColor? {
        didSet {
            if (textField.isAddButton) {
                textField.layer.borderColor = borderColor?.cgColor
            }
            super.borderColor = borderColor
        }
    }
    
    override open dynamic var textFont: UIFont {
        didSet {
            textField.font = textFont
            super.textFont = textFont
        }
    }
    
    override init(frame: CGRect) {
        textField = TagListTextField()
        super.init(frame: frame)
        addSubview(textField)
        textField.setupForTagListView(tagListView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        textField = TagListTextField()
        super.init(coder: aDecoder)
        addSubview(textField)
        textField.setupForTagListView(tagListView: self)
    }
    
    func textFieldOrigin() -> CGPoint {
        if rows > 0 {
            let x = rowViews[rows - 1].frame.size.width
            let y = CGFloat(rows - 1) * (tagViewHeight + marginY)
            if (isTextFieldOnNewLine) {
                return textFieldOriginOnNewLine()
            }
            return CGPoint(x: x, y: y)
        }
        else {
            return CGPoint(x: 0, y: 0)
        }
    }
    
    var isTextFieldOnNewLine : Bool {
        if rows > 0 {
            let x = rowViews[rows - 1].frame.size.width
            let w = self.frame.size.width - x - marginX
            if (w < textFieldMinWidth) {
                return true
            }
            return false
        }
            return true
    }
    
    func textFieldOriginOnNewLine() -> CGPoint {
        let y = CGFloat(rows) * (tagViewHeight + marginY)
        return CGPoint(x: 0, y: y)
    }

    override var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if isTextFieldOnNewLine {
            height += tagViewHeight + marginY
        }
        if rows == 0 {
            // TODO: calculate height?
            height = 26
        } else {
            height -= marginY
        }
        return CGSize(width: frame.width, height: height)
    }
    
    @discardableResult
    func addTagViewByTextField(_ title: String) -> TagView {
        var result = createNewTagView(title)
        if (dataDelegate?.tagShouldBeAdded?(result.currentTitle!, reason: .byUser, sender: self) ?? true) {
            result = super.addTagView(result)
            dataDelegate?.tagAddedOrInserted?(result.currentTitle!, reason: .byUser, tagView: result, sender: self)
        }
        updateTextField()
        return result
    }
    
    @discardableResult
    override open func addTagViews(_ tagViews: [TagView]) -> [TagView] {
        var validatedTagViews : [TagView] = []
        for tagView in tagViews {
            if (dataDelegate?.tagShouldBeAdded?(tagView.currentTitle!, reason: .byCode, sender: self) ?? true) {
                validatedTagViews.append(tagView)
            }
        }
        
        let result = super.addTagViews(validatedTagViews)
        for tag in result {
            dataDelegate?.tagAddedOrInserted?(tag.currentTitle!, reason: .byCode, tagView: tag, sender: self)
        }
        
        updateTextField()
        
        return result
    }
    
    @discardableResult
    override open func addTagView(_ tagView: TagView) -> TagView {
        var result = tagView
        if (dataDelegate?.tagShouldBeAdded?(tagView.currentTitle!, reason: .byCode, sender: self) ?? true) {
            result = super.addTagView(tagView)
            dataDelegate?.tagAddedOrInserted?(result.currentTitle!, reason: .byCode, tagView: result, sender: self)
        }

        updateTextField()
        
        return result
    }
    
    @discardableResult
    override open func insertTagView(_ tagView: TagView, at index: Int) -> TagView {
        var result = tagView
        if (dataDelegate?.tagShouldBeAdded?(tagView.currentTitle!, reason: .byCode, sender: self) ?? true) {
            result = super.insertTagView(tagView, at: index)
            dataDelegate?.tagAddedOrInserted?(result.currentTitle!, reason: .byCode, tagView: result, sender: self)
        }

        updateTextField()
        return result
    }

    /*
    override open func removeTag(_ title: String) {
        dataDelegate?.tagWillBeRemoved?(title, sender: self)
        super.removeTag(title)
        if (textField.isAddButton) {
            textField.textFieldToFakeButton(true)
        } else {
            textField.textFieldToInputMode(true)
        }
    }*/
    
    override open func removeTagView(_ tagView: TagView) {
        dataDelegate?.tagWillBeRemoved?(tagView.currentTitle!, sender: self)
        
        super.removeTagView(tagView)
        updateTextField()
        
        
    }
    
    override open func removeAllTags() {
        for tagView in tagViews {
            dataDelegate?.tagWillBeRemoved?(tagView.currentTitle!, sender: self)
        }
        super.removeAllTags()
        updateTextField()
    }
    
    private func updateTextField() {
        if (textField.isAddButton) {
            textField.textFieldToFakeButton(true)
        } else {
            textField.textFieldToInputMode(true)
        }
    }

}
