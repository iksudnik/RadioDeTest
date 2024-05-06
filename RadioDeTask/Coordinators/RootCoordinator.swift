//
//  RootCoordinator.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit

final class RootCoordinator: Coordinator {
	let window: UIWindow
	let appContext: AppContext
	
	private(set) var rootViewController: UIViewController {
		didSet {
			self.window.rootViewController = rootViewController
			self.window.makeKeyAndVisible()
		}
	}
	
	var childCoordinators: [Coordinator] = []
	
	init(window: UIWindow, appContext: AppContext) {
		self.window = window
		self.appContext = appContext
		self.rootViewController = UIViewController()
	}
	
	func prepare() -> UIViewController? {
		return nil
	}
	
	func start() {
		showEpisodesList()
	}
	
	private func showEpisodesList() {
		let mainCoordinator = MainCoordinator(appContext: appContext)
		
		guard let vc = mainCoordinator.prepare() else { return }
		
		addChild(coordinator: mainCoordinator)
		mainCoordinator.start()
		rootViewController = vc
	}
}
