//
//  UITableView_KeyboardNotification.swift
//  Assignment4
//


import UIKit


extension UIViewController {
	func adjustSafeArea(forWillShowKeyboardNotification notification: Notification) {
		guard let userInfo = notification.userInfo as? Dictionary<String, AnyObject>, let rectValue = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue, let animationCurveRawValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue, let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRawValue) else {
			return
		}

		let convertedRect = self.view.convert(rectValue, from: nil)
		let intersectionHeight = convertedRect.intersection(self.view.bounds).integral.height
		UIView.animate(withDuration: animationDuration, delay: 0, options: [animationCurve.animationOption], animations: {
			self.additionalSafeAreaInsets.bottom = intersectionHeight - (self.view.superview?.safeAreaInsets.bottom ?? 0)
		})
	}

	func adjustSafeArea(forWillHideKeyboardNotification notification: Notification) {
		guard let userInfo = notification.userInfo as? Dictionary<String, AnyObject>, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue, let animationCurveRawValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue, let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRawValue) else {
			return
		}

		UIView.animate(withDuration: animationDuration, delay: 0, options: [animationCurve.animationOption], animations: {
			self.additionalSafeAreaInsets.bottom = 0
		})
	}
}


extension UIViewAnimationCurve {
	var animationOption: UIViewAnimationOptions {
		let result: UIViewAnimationOptions
		switch self {
		case .easeIn:
			result = .curveEaseIn
		case .easeInOut:
			result = .curveEaseInOut
		case .easeOut:
			result = .curveEaseOut
		case .linear:
			result = .curveLinear
		}

		return result
	}
}
