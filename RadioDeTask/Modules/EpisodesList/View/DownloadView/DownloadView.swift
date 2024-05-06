//
//  DownloadView.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit

final class DownloadView: UIView {
	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var percentLabel: UILabel!
	
	private var state: DownloadState = .notDownloaded
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		if subviews.isEmpty {
			loadViewFromNib()
		}
	}
	
	private func loadViewFromNib() {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: "DownloadView", bundle: bundle)
		guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
		view.frame = bounds
		addSubview(view)
		view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = 8
		clipsToBounds = true
	}
	
	func update(state: DownloadState) {
		iconView.image = state.image
		if case let .inProgress(percent) = state {
			percentLabel.isHidden = false
			percentLabel.text = "\(percent)%"
		} else {
			percentLabel.isHidden = true
		}
	}
}

private extension DownloadState {
	var image: UIImage? {
		return switch self {
		case .notDownloaded: UIImage(systemName: "arrow.down.circle.fill")
		case .inProgress: UIImage(systemName: "x.circle.fill")
		case .downloaded: UIImage(systemName: "checkmark.circle.fill")
		}
	}
}
