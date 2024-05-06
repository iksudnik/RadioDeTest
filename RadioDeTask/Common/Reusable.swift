//
//  Reusable.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation

protocol Reusable {
	associatedtype Data
	
	static var identifier: String { get }
	
	func setup(with data: Data)
}

extension Reusable {
	static var identifier: String {
		return String(describing: self)
	}
}
