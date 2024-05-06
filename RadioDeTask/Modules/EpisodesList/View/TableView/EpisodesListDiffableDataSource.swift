//
//  EpisodesListDiffableDataSource.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit

typealias EpisodesListDiffableDataSource = UITableViewDiffableDataSource<Section, EpisodeViewModel>

class EpisodesListDataSource: EpisodesListDiffableDataSource {
	
	init(tableView: UITableView) {
		super.init(tableView: tableView) { tableView, indexPath, item in
			let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier, for: indexPath) as! EpisodeCell
			cell.setup(with: item)
			return cell
		}
	}
}

extension EpisodesListDataSource {
	func applySnapshot(items: [EpisodeViewModel], animatingDifferences: Bool = true) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, EpisodeViewModel>()
		snapshot.appendSections([.main])
		snapshot.appendItems(items, toSection: .main)
		apply(snapshot, animatingDifferences: animatingDifferences)
	}
}
