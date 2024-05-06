//
//  EpisodeEntity.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation

extension EpisodeEntity {
	func update(from episode: Episode) {
		id = episode.id
		title = episode.title
		episodeDescription = episode.description
		publishDate = episode.publishDate
		duration = episode.duration
		logoLink = episode.parentLogo300x300
		remoteUrl = episode.url
	}
	
	func toEpisode() -> Episode {
		return .init(id: id!,
					 title: title!,
					 description: episodeDescription!,
					 publishDate: publishDate,
					 duration: duration,
					 parentLogo300x300: logoLink!,
					 url: remoteUrl!,
					 isDownloaded: audioData != nil)
	}
}
