//
//  ProblemListViewController.swift
//  Assignment2
//
//  Created by Charles Augustine on 7/5/15.
//
//


import UIKit


class ProblemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	// UITableViewDataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ProblemListRow.Rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) 
		cell.textLabel?.text = ProblemListRow.Rows[indexPath.row].cellText

		return cell
	}

	// UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: ProblemListRow.Rows[indexPath.row].segue, sender: self)
	}

	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		problemListTable.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		preferredContentSize = CGSize(width: 320.0, height: 600.0)
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var problemListTable: UITableView!


	// MARK: ProblemListRow
	private enum ProblemListRow {
		case problemOne
		case problemTwo
		case problemThree
		case problemFour
		case problemFive
		case problemSix

		var cellText: String {
			let text: String
			switch self {
			case .problemOne:
				text = "Problem One"
			case .problemTwo:
				text = "Problem Two"
			case .problemThree:
				text = "Problem Three"
			case .problemFour:
				text = "Problem Four"
			case .problemFive:
				text = "Problem Five"
			case .problemSix:
				text = "Problem Six"
			}

			return text
		}

		var segue: String {
			let text: String
			switch self {
			case .problemOne:
				text = "ProblemOneSegue"
			case .problemTwo:
				text = "ProblemTwoSegue"
			case .problemThree:
				text = "ProblemThreeSegue"
			case .problemFour:
				text = "ProblemFourSegue"
			case .problemFive:
				text = "ProblemFiveSegue"
			case .problemSix:
				text = "ProblemSixSegue"
			}

			return text
		}

		fileprivate static let Rows: Array<ProblemListRow> = [.problemOne, .problemTwo, .problemThree, .problemFour, .problemFive, .problemSix]
	}
}
