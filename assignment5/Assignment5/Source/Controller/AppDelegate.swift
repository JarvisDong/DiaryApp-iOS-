//
//  AppDelegate.swift
//  Assignment5
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		UINavigationBar.appearance().isTranslucent = false

		return true
	}

	// MARK: Properties
	var window: UIWindow?
}

