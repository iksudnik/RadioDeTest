//
//  AppContext.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation

struct AppContext {
	let apiClient = ApiClient.live
	let databaseClient = DatabaseClient.live
	let downloadManager = DownloadManager.live
	
	let repository: Repository
	
	init() {
		repository = Repository.live(database: databaseClient, apiClient: apiClient)
	}
}
