//
//  CatImageCell.swift
//  Assignment5
//
//  Created by Charles Augustine on 7/15/18.
//


import UIKit


class CatImageCell: UICollectionViewCell {
	// MARK: Configuration
	func update(withImageName imageName: String) {
		catImageView.image = UIImage(named: imageName)
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var catImageView: UIImageView!
}
