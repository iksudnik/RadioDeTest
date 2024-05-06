//
//  DatabaseClient.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation
import CoreData

// MARK: - Interface

struct DatabaseClient {
	var episodes: @MainActor () throws -> [Episode]
	var audioData: (_ id: Episode.ID) -> Data?
	var saveEpisodes: @MainActor ([Episode]) async throws -> Void
	var updateIsDownloaded: @MainActor (_ data: Data?, _ episodeId: String) async throws -> Void
}

enum DatabaseClientError: Error {
	case objectNotExists
}


// MARK: - Live client

extension DatabaseClient {
	
	static var live: Self {
		
		var viewContext: NSManagedObjectContext {
			return persistentContainer.viewContext
		}
		
		lazy var persistentContainer: NSPersistentContainer = {
			let container = NSPersistentContainer(name: "RadioDeTask")
			container.loadPersistentStores { _, error in
				if let error = error as NSError? {
					fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
				}
			}
			container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			return container
		}()
		
		return Self(episodes: {
			
			let request = EpisodeEntity.fetchRequest()
			let sortDescriptor = NSSortDescriptor(keyPath: \EpisodeEntity.publishDate, ascending: false)
			request.sortDescriptors = [sortDescriptor]
			let entities = try viewContext.fetch(request)
			
			return entities.map { $0.toEpisode() }
			
		}, audioData: { id in
			let request = EpisodeEntity.fetchRequest()
			request.predicate = NSPredicate(format: "id == %@", id)
			
			let entities = try? viewContext.fetch(request)
			return entities?.first?.audioData
		}, saveEpisodes: { episodes in
			
			try await viewContext.perform {
				for episode in episodes {
					let entity = EpisodeEntity(context: viewContext)
					entity.update(from: episode)
				}
				try viewContext.save()
			}
		}, updateIsDownloaded: { data, episodeId in
			
			let request = EpisodeEntity.fetchRequest()
			request.predicate = NSPredicate(format: "id == %@", episodeId)
			
			let entities = try viewContext.fetch(request)
			
			guard let entity = entities.first else {
				throw DatabaseClientError.objectNotExists
			}
			
			try await viewContext.perform {
				entity.audioData = data
				try viewContext.save()
			}
		})
	}
}


// MARK: Mock client

extension DatabaseClient {
	static var mock: Self {
		return Self(episodes: {
			return [.mock1, .mock2]
		}, audioData: { _ in
			return nil
		}, saveEpisodes: { _ in
			
		},updateIsDownloaded: { _, _ in })
	}
}
