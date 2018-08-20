//
//  CatService.swift
//  Assignment4
//


import Foundation


class CatService {
    // MARK: Service
    // Remove the fatalError call and return an array of tuples, where each tuple contains the title of the category and the subtitle text

	func catCategories() -> Array<(title: String, subtitle: String)> {
        var array: Array<(title: String, subtitle: String)> = []
        
        for catValue in catValues {
            let catCategoryString = catValue[titleKey] as! String
            let pictureNamesString = (catValue[imageNamesKey] as! NSArray) as! Array<String>
            let subtitle = "Contain \(pictureNamesString.count) images"
            let cellTuple:(title: String, subtitle: String) = (catCategoryString, subtitle)
            array.append(cellTuple)
        }
        if (array.count == 0) {
            fatalError("catCategories() not implemented")
        }
        else {
            return array
        }
	}

	func imageNamesForCategory(atIndex index: NSInteger) -> Array<String> {
		//Remove the fatalError call and return the array of image names for the cat category specified by the index
        let imageNames: Array<String>? = catValues[index][imageNamesKey] as? Array<String>
        
        if let imageName = imageNames {
            return imageName
        }
        else {
            fatalError("imageNamesForCategory(atIndex:) not implemented")
        }
        
	}

	// MARK: Initialization
	private init() {
		let catValuesDataURL = Bundle.main.url(forResource: "CatValues", withExtension: "plist")!
		let catValuesData = try! Data(contentsOf: catValuesDataURL)
		catValues = try! PropertyListSerialization.propertyList(from: catValuesData, options: [], format: nil) as! Array<Dictionary<String, Any>>
	}

	// MARK: Properties (Private)
	private let catValues: Array<Dictionary<String, Any>>

	// MARK: Properties (Private, Constant)
	private let titleKey = "CategoryTitle"
	private let imageNamesKey = "ImageNames"

	// MARK: Properties (Static)
	static let shared = CatService()
}
