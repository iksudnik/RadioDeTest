//
//  EpisodesListViewModel.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation
import Combine

enum ViewState {
	case idle
	case loading
	case success([EpisodeViewModel])
	case error(Error)
}


final class EpisodesListViewModel {
	
	private let repository: Repository
	private let databaseClient: DatabaseClient
	private let downloadManager: DownloadManager
	
	private var episodes: [Episode] = []
	
	private var cellModels: [EpisodeViewModel] = []
	
	private var cancellables = Set<AnyCancellable>()
	
	@Published private(set) var viewState: ViewState = .idle
	@Published private(set) var selectedModel: EpisodeViewModel? = nil
	
	init(repository: Repository,
		 databaseClient: DatabaseClient,
		 downloadManager: DownloadManager) {
		self.repository = repository
		self.databaseClient = databaseClient
		self.downloadManager = downloadManager
	}
}

// MARK: - Public

extension EpisodesListViewModel {
	func loadData() async {
		episodes = []
		
		viewState = .loading
		do {
			episodes = try await repository.episodes()
			self.cellModels = episodes.map(EpisodeViewModel.init(from:))
			viewState = .success(cellModels)
		} catch {
			viewState = .error(error)
		}
	}
	
	func didSelectItem(_ index: Int) async {
		let model = cellModels[index]
		if case .downloaded = model.downloadState {
			selectedModel = model
			return
		}
		
		guard let url = model.remoteUrl else { return }
		
		if case .inProgress = model.downloadState {
			downloadManager.cancel(url)
			return
		}
		
		downloadManager.download(url)
			.sink { [weak self] event in
				switch event {
				case .initiated:
					model.downloadState = .inProgress(0)
				case let .progress(progress):
					let percent = Int(progress * 100)
					model.downloadState = .inProgress(max(0, min(100, percent)))
				case let .success(data):
					self?.updateFileData(data, for: model)
				case .cancelled:
					model.downloadState = .notDownloaded
				}
			}.store(in: &cancellables)
	}
}

// MARK: - Private

private extension EpisodesListViewModel {
	func updateFileData(_ data: Data, for model: EpisodeViewModel) {
		Task {
			do {
				try await databaseClient.updateIsDownloaded(data, model.id)
				model.downloadState = .downloaded
			} catch {
				try? await databaseClient.updateIsDownloaded(nil, model.id)
				model.downloadState = .notDownloaded
				print("Failed to save file")
			}
		}
	}
}
