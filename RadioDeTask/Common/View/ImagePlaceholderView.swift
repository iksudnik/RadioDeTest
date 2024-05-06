//
//  ImagePlaceholderView.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import UIKit

final class ImagePlaceholderView: UIView {
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.color = .white
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .systemGray
		translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(activityIndicator)
		
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		
		activityIndicator.startAnimating()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
