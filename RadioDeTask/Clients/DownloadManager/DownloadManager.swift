//
//  DownloadManager.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation
import Combine

// MARK: - Interface

struct DownloadManager {
	var download: (_ remoteUrl: URL) -> AnyPublisher<DownloadEvent, Never>
	var cancel: (URL) -> Void
}

// MARK: - Live client

extension DownloadManager {
	static var live: Self {
		
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 5
		
		var downloads: [URL: DownloadOperation] = [:]
		
		lazy var downloadSession: URLSession = {
			let configuration = URLSessionConfiguration.default
			return URLSession(configuration: configuration,
							  delegate: nil,
							  delegateQueue: .main)
		}()
		
		return Self(download: { url in
			
			guard downloads[url] == nil else { return downloads[url]!.publisher.eraseToAnyPublisher() }
			
			let downloadOperation = DownloadOperation(session: downloadSession, url: url)
			downloadOperation.onCompletion = {
				downloads[url] = nil
			}
			queue.addOperation(downloadOperation)
			downloads[url] = downloadOperation
			return downloadOperation.publisher.eraseToAnyPublisher()
		}, cancel: { url in
			downloads[url]?.cancel()
			downloads[url] = nil
		})
	}
}


// MARK: Mock client

extension DownloadManager {
	static var mock: Self {
		return Self(download: { _ in
			return Just(DownloadEvent.cancelled).eraseToAnyPublisher()
		}, cancel:  { _ in })
	}
}
