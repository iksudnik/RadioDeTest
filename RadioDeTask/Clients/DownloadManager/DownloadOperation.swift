//
//  DownloadOperation.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation
import Combine

enum DownloadEvent {
	case initiated
	case progress(Double)
	case success(data: Data)
	case cancelled
}

class DownloadOperation: Operation {
	private var task: URLSessionDataTask?
	private var session: URLSession
	private var url: URL
	
	private var progressObservation: NSKeyValueObservation?
	
	var publisher = PassthroughSubject<DownloadEvent, Never>()
	var onCompletion: (() -> Void)?
	
	init(session: URLSession, url: URL) {
		self.session = session
		self.url = url
	}
	
	override func main() {
		guard !isCancelled else { return }
		
		task = session.dataTask(with: url) { [weak self] data, response, error in
			guard let self else { return }
			
			if let data = data, error == nil {
				self.publisher.send(.success(data: data))
				self.onCompletion?()
			} else {
				self.publisher.send(.cancelled)
				self.onCompletion?()
			}
		}
		
		progressObservation = task?.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
			self?.publisher.send(.progress(progress.fractionCompleted))
		}
		
		task?.resume()
	}
	
	override func cancel() {
		super.cancel()
		progressObservation?.invalidate()
		task?.cancel()
		publisher.send(.cancelled)
	}
}
