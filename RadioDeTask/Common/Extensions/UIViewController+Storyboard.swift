//
//  UIViewController+Storyboard.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 5.05.24.
//

import UIKit

extension UIViewController {
	
	static func fromStoryboard<T: UIViewController>() -> T {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let identifier = String(describing: T.self)
		
		guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
			fatalError("ViewController with identifier \(identifier) is not of expected type \(T.self)")
		}
		
		return viewController
	}
}
