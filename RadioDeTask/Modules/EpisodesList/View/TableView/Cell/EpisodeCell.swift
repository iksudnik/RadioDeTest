//
//  EpisodeCell.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit
import Combine

enum DownloadState {
	case notDownloaded
	case inProgress(_ percent: Int)
	case downloaded
}

extension DownloadState: Equatable, Hashable {
	static func == (lhs: DownloadState, rhs: DownloadState) -> Bool {
		switch (lhs, rhs) {
		case (.notDownloaded, .notDownloaded),
			(.downloaded, .downloaded):
			return true
		case let (.inProgress(lhs), .inProgress(rhs)):
			return lhs == rhs
		default:
			return false
		}
	}
}

final class EpisodeViewModel {
	let id: String
	let title: String
	let description: String
	let publishDate: String
	let duration: String
	let logoUrl: URL?
	let remoteUrl: URL?
	
	@Published var downloadState: DownloadState = .notDownloaded
	
	init(from episode: Episode) {
		self.id = episode.id
		self.title = episode.title
		self.description = episode.description
		self.publishDate = DateFormatter.publushDateFormatter.string(from: episode.publishDateFixed)
		self.duration = DateComponentsFormatter.durationFormatter.string(from: episode.duration) ?? "-"
		self.logoUrl = URL(string: episode.parentLogo300x300)
		self.remoteUrl = URL(string: episode.url)
		
		if episode.isDownloaded {
			downloadState = .downloaded
		}
	}
}

extension EpisodeViewModel: Hashable {
	static func == (lhs: EpisodeViewModel, rhs: EpisodeViewModel) -> Bool {
		return lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

final class EpisodeCell: UITableViewCell {
	
	@IBOutlet weak var logoImageView: UIImageView! {
		didSet {
			logoImageView.layer.cornerRadius = 6
			logoImageView.clipsToBounds = true
		}
	}
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var downloadView: DownloadView!
	@IBOutlet weak var durationLabel: UILabel!
	
	private var cancellable: AnyCancellable?
	
	override func prepareForReuse() {
		super.prepareForReuse()
		cancellable?.cancel()
		cancellable = nil
	}
}

extension EpisodeCell: Reusable {
	
	func setup(with data: EpisodeViewModel) {
		
		titleLabel.text = data.title
		descriptionLabel.text = data.description
		dateLabel.text = data.publishDate
		durationLabel.text = data.duration
		
		cancellable = data.$downloadState
			.receive(on: DispatchQueue.main)
			.sink { [weak self] state in
				self?.downloadView.update(state: data.downloadState)
			}
		
		Task {
			await logoImageView.loadImage(from: data.logoUrl,
										  placeholder: ImagePlaceholderView.init)
		}
	}
}
