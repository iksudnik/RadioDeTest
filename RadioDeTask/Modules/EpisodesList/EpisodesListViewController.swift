//
//  EpisodesListViewController.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit
import Combine

enum Section: Int {
	case main
}

final class EpisodesListViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			setupTableView()
		}
	}
	
	private var viewModel: EpisodesListViewModel?
	private var dataSource: EpisodesListDataSource!
	
	private var cancellables = Set<AnyCancellable>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = AppStrings.episodesTitle
		updateForViewModel()
		
		Task {
			await viewModel?.loadData()
		}
	}
	
	func setViewModel(_ viewModel: EpisodesListViewModel) {
		self.viewModel = viewModel
		updateForViewModel()
	}
	
	private func updateForViewModel() {
		guard isViewLoaded, let viewModel else { return }
		
		viewModel.$viewState
			.receive(on: DispatchQueue.main)
			.sink { [weak self] state in
				self?.didUpdate(with: state)
			}.store(in: &cancellables)
	}
	
	private func setupTableView() {
		
		dataSource = .init(tableView: tableView)
		
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
}

// MARK: - EpisodesListViewModel updates

private extension EpisodesListViewController {
	
	func didUpdate(with state: ViewState) {
		switch state {
		case .idle:
			showEmptyState()
		case .loading:
			showLoading()
		case let .success(episodes):
			contentUnavailableConfiguration = .none
			dataSource.applySnapshot(items: episodes)
			if episodes.isEmpty {
				showEmptyState()
			}
		case .error(_):
			showError()
			dataSource.applySnapshot(items: [])
		}
	}
	
	func showEmptyState() {
		var config = UIContentUnavailableConfiguration.empty()
		config.image = UIImage(systemName: "waveform")
		config.text = AppStrings.episodesTitle
		config.secondaryText = AppStrings.emptyListTitle
		contentUnavailableConfiguration = config
	}
	
	func showLoading() {
		var config = UIContentUnavailableConfiguration.loading()
		config.text = AppStrings.loadingText
		config.textProperties.font = .boldSystemFont(ofSize: 18)
		contentUnavailableConfiguration = config
	}
	
	func showError() {
		var errorConfig = UIContentUnavailableConfiguration.empty()
		errorConfig.image = UIImage(systemName: "exclamationmark.circle.fill")
		errorConfig.text = AppStrings.fetchingErrorTitle
		errorConfig.secondaryText = AppStrings.fetchingErrorSubtitle
		
		var buttonConfig =  UIButton.Configuration.filled()
		buttonConfig.title = AppStrings.retryTitle
		errorConfig.button = buttonConfig
		
		errorConfig.buttonProperties.primaryAction = UIAction.init() { _ in
			
			Task { [weak self] in
				guard let self else { return }
				await viewModel?.loadData()
			}
		}
		contentUnavailableConfiguration = errorConfig
	}
}

// MARK: - UITableViewDelegate

extension EpisodesListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Task {
			await viewModel?.didSelectItem(indexPath.row)
		}
	}
}
