//
//  CatImagesViewController.swift
//  Assignment4
//
//  Created by Haojun Dong on 7/22/18.
//

import Foundation
import UIKit

class CatImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedIndex: Int!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatService.shared.imageNamesForCategory(atIndex: selectedIndex).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        let names = CatService.shared.imageNamesForCategory(atIndex: selectedIndex)
        collectionViewCell.imageView.image = UIImage(named:names[indexPath.row])
        return collectionViewCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var CollectionView: UICollectionView!
}

