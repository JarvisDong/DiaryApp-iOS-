//
//  Double_Random.swift
//  Assignment1
//
//  Created by Charles Augustine.
//
//


import Foundation


extension Double {
	static func random() -> Double {
		return Double(arc4random()) / Double(UInt32.max)
	}
}