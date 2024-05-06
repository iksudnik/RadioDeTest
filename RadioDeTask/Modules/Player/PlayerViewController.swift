//
//  PlayerViewController.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 25.02.24.
//

import UIKit
import Combine

final class PlayerViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var playButton: UIButton!
	
	private var viewModel: PlayerViewModel?
	private var cancellables = Set<AnyCancellable>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = AppStrings.playerTitle
		updateForViewModel()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		viewModel?.cleanUp()
	}
	
	func setViewModel(_ viewModel: PlayerViewModel) {
		self.viewModel = viewModel
		updateForViewModel()
	}
	
	private func updateForViewModel() {
		guard isViewLoaded, let viewModel else { return }
		
		titleLabel.text = viewModel.title
		
		Task {
			await imageView.loadImage(from: viewModel.imageUrl,
									  placeholder: ImagePlaceholderView.init)
		}
		
		viewModel.$isPlaying
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isPlaying in
				let imageName = isPlaying ? "pause.rectangle" : "play.rectangle"
				let image = UIImage(systemName: imageName)
				self?.playButton.setImage(image, for: .normal)
			}.store(in: &cancellables)
		
	}
	
	@IBAction func tappedPlayButton() {
		viewModel?.togglePlayPause()
	}
}
