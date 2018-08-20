//
//  CategoryListViewController.swift
//  Assignment4
//
//  Created by Haojun Dong on 7/22/18.
//

import UIKit

class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CatService.shared.catCategories().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = CatService.shared.catCategories()[indexPath.row].title
        cell.detailTextLabel?.text = CatService.shared.catCategories()[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToImage" {
            let catImagesViewController = segue.destination as! CatImagesViewController
            let indexPath = catTableView.indexPathForSelectedRow!.row
            catImagesViewController.selectedIndex = indexPath
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var catTableView: UITableView!
}
