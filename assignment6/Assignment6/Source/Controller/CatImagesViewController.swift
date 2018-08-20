//
//  CatImagesViewController.swift
//  Assignment6
//


import CoreData
import UIKit


class CatImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return resultsController?.sections?[section].numberOfObjects ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
		let image = resultsController!.object(at: indexPath)
		cell.update(withImageName: image.name!)

		return cell
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView.reloadData()
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		resultsController = CatService.shared.images(for: category)
		resultsController?.delegate = self

		let cellSize = (view.frame.width - 20) / 2
		(collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: cellSize, height: cellSize)
	}

	// MARK: Properties
	var category: Category!

	// MARK: Properties (Private)
	private var resultsController: NSFetchedResultsController<Image>?

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var collectionView: UICollectionView!
}
