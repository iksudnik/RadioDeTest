//
//  Coordinator.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit

/// Just simplified version of Coordinator
/// We don't need coordinators for such task but I decided to add it to separate routing logic

protocol Coordinator: AnyObject {
	var childCoordinators: [Coordinator] { get set }
	var rootViewController: UIViewController { get }
	
	func prepare() -> UIViewController?
	func start()
}

extension Coordinator {
	func addChild(coordinator: Coordinator) {
		childCoordinators.append(coordinator)
	}
	
	func removeChild(coordinator: Coordinator) {
		childCoordinators = childCoordinators.filter { $0 !== coordinator }
	}
}
