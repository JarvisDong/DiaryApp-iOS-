//
//  JournalCellWithTags.swift
//  EmojiDaily3
//
//  Created by Haojun Dong on 8/19/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import UIKit

class JournalCellWithTags : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
