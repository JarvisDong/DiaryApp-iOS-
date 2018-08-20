//
//  ProblemFiveViewController.swift
//  Assignment2
//
//  Created by Charles Augustine on 7/5/15.
//
//


import UIKit


class ProblemFiveViewController: UIViewController {
	// MARK: IBAction
	@IBAction private func changeText(_ sender: AnyObject) {
		guard let someTextLabel = detectedTextLabel else {
			let alertController = UIAlertController(title: nil, message: "Failed to find the text label", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default))

			present(alertController, animated: true)

			return
		}

		if shortTextShowing {
			someTextLabel.text = ProblemFiveViewController.ProblemFiveLongLabelText

			shortTextShowing = false
		}
		else {
			someTextLabel.text = ProblemFiveViewController.ProblemFiveShortLabelText

			shortTextShowing = true
		}

		updateTextLabelLabel()
	}

	// MARK: Private
	private func updateTextLabelLabel() {
		if shortTextShowing {
			textLabelLabel.text = "Short text showing"
		}
		else {
			textLabelLabel.text = "Long text showing"
		}
	}

	private func findLabel(_ result: UILabel?, view: UIView) -> UILabel? {
		guard result == nil else {
			return result
		}

		let newResult: UILabel?
		if let someLabel = view as? UILabel, someLabel !== textLabelLabel {
			newResult = someLabel
		}
		else if view.isMember(of: UIView.self) {
			newResult = view.subviews.reduce(nil, findLabel)
		}
		else {
			newResult = nil
		}

		return newResult
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		detectedTextLabel = findLabel(nil, view: self.view)
		detectedTextLabel?.numberOfLines = 0

		if detectedTextLabel != nil {
			changeText(self)
		}
	}

	// MARK: Properties (Private)
	private var shortTextShowing = false

	private weak var detectedTextLabel: UILabel?

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var textLabelLabel: UILabel!

	// MARK: Properties (Private Static Constant)
	private static let ProblemFiveShortLabelText = "Short Label Text"
	private static let ProblemFiveLongLabelText = "Long Label Text: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}
