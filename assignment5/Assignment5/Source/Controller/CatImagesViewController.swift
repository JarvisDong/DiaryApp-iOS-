//
//  CatImagesViewController.swift
//  Assignment5
//
//  Created by Charles Augustine on 7/15/18.
//


import UIKit
import CoreData

class CatImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
        
//        let imageName = CatService.shared.imageNamesForCategory(atIndex: categoryIndex)[indexPath.item]
//        cell.update(withImageName: imageName)
        cell.update(withImageName: fetchedResultsController.object(at: indexPath).imagename!)
		return cell
	}
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
    
	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
        
        fetchedResultsController = CatService.shared.images(for: categoryIndex)
        
	}

	// MARK: Properties
	var categoryIndex: Category! = nil
    var fetchedResultsController: NSFetchedResultsController<Image>!

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var collectionView: UICollectionView!
}
