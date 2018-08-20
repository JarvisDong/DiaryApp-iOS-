//
//  MainViewController.swift
//  Assignment3
//
//  Created by Haojun Dong on 7/15/18.
//  Copyright © 2018 CIS 399. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DetailViewControllerDelegate{

    func ActionPerformer() {
        let count = MainViewController.increament()
        if count == 1 {
            presentedLabel.text = "The detail action has been performed 1 time"
        }
        else {
            presentedLabel.text = "The detail action has been performed \(count) times"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static var presentedCount = 0
    static func increament() -> Int {
        presentedCount += 1
        return presentedCount
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {

            let detailViewController: DetailViewController = segue.destination as! DetailViewController
            detailViewController.delegate = self
        }

        
    }

    
    @IBOutlet weak var presentedLabel: UILabel!
    
    @IBAction func ModalDidFinish(_ sender: UIStoryboardSegue) {
    }
}


