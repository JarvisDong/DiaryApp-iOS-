//
//  AppDelegate.swift
//  Assignment2
//
//  Created by Charles Augustine on 7/5/15.
//
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		let splitViewController = window?.rootViewController as! UISplitViewController
		splitViewController.preferredDisplayMode = .allVisible

		return true
	}

	// MARK: Properties
	var window: UIWindow?
}

