//
//  MainCoordinator.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit
import Combine

final class MainCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var rootViewController: UIViewController {
		navigationController
	}
	
	private let navigationController = UINavigationController()
	private let appContext: AppContext
	private var cancellables = Set<AnyCancellable>()
	
	init(appContext: AppContext) {
		self.appContext = appContext
	}
	
	func prepare() -> UIViewController? {
		return navigationController
	}
	
	func start() {
		let viewModel = EpisodesListViewModel(repository: appContext.repository,
											  databaseClient: appContext.databaseClient,
											  downloadManager: appContext.downloadManager)
		viewModel.$selectedModel
			.compactMap { $0 }
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				self?.openPlayer(for: model)
			}.store(in: &cancellables)
		
		let viewController: EpisodesListViewController = .fromStoryboard()
		viewController.setViewModel(viewModel)
		navigationController.setViewControllers([viewController], animated: false)
	}
	
	func openPlayer(for model: EpisodeViewModel) {
		guard case .downloaded = model.downloadState,
			  let audioData = appContext.databaseClient.audioData(model.id) else {
			return
		}
		let viewModel = PlayerViewModel(audioData: audioData, imageUrl: model.logoUrl, title: model.title)
		
		let viewController: PlayerViewController = .fromStoryboard()
		viewController.setViewModel(viewModel)
		navigationController.pushViewController(viewController, animated: true)
		
	}
}

