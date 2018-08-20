//
//  CategoryListViewController.swift
//  Assignment6
//


import CoreData
import UIKit


class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
	// MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return resultsController?.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		let category = resultsController!.object(at: indexPath)
		cell.textLabel?.text = category.title
		cell.detailTextLabel?.text = category.subtitle

		return cell
	}

	// MARK: UISearchBarDelegate
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.reloadData()
	}

	// MARK: View Management
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "CatImagesSegue" {
			let catImagesViewController = segue.destination as! CatImagesViewController
			let indexPath = tableView.indexPathForSelectedRow!
			catImagesViewController.category = resultsController!.object(at: indexPath)

			tableView.deselectRow(at: indexPath, animated: true)
		}
		else {
			super.prepare(for: segue, sender: sender)
		}
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		resultsController = CatService.shared.catCategories()
		resultsController?.delegate = self

		let willShowObserverToken = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] in
			self.adjustSafeArea(forWillShowKeyboardNotification: $0)
		}
		let willHideObserverToken = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] in
			self.adjustSafeArea(forWillHideKeyboardNotification: $0)
		}
		observerTokens += [willShowObserverToken, willHideObserverToken]
	}

	// MARK: Deinitialization
	deinit {
		for observerToken in observerTokens {
			NotificationCenter.default.removeObserver(observerToken)
		}
	}

	// MARK: Properties (Private)
	private var resultsController: NSFetchedResultsController<Category>?
	private var observerTokens = Array<Any>()

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var tableView: UITableView!
}
