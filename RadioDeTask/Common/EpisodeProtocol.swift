//
//  EpisodeProtocol.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 25.02.24.
//

import Foundation

protocol EpisodeProtocol: Identifiable {
	var id: String { get }
}

extension Episode: EpisodeProtocol {}

extension EpisodeViewModel: EpisodeProtocol {}
