//
//  DetailViewContoller.swift
//  Assignment3
//
//  Created by Haojun Dong on 7/15/18.
//  Copyright © 2018 CIS 399. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func ActionPerformer()
}

class DetailViewController: UIViewController{
    weak var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Mark: Time Label
    override func viewWillAppear(_ animated: Bool) {
        let currentTimeValue = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        currentTimeLabel.text = "Presented at \(currentTimeValue)"
        
    }
    

    
    @IBOutlet weak var currentTimeLabel: UILabel!

    @IBAction func send(_ sender: UIButton) {
        viewWillAppear(true)
        delegate?.ActionPerformer()
    }
    


}


