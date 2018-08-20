//
//  Journal+CoreDataClass.swift
//  EmojiDaily3
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//
//

import Foundation
import CoreData


public class Journal: NSManagedObject {
    
    // Custom deletion rule for invalidate tags
    override public func prepareForDeletion() {
        for tag in (self.tag?.allObjects)! {
            if let validTag = (tag as? Tag) {
                if (validTag.journal?.count ?? 0 <= 1) {
                    JournalServices.shared.deleteTag(tag: validTag)
                }
            }
        }
        
        // Nullify other valid tags based on delete rule in coredata
        super.prepareForDeletion()
    }

}
