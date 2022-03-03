//
//  CheckersPiece.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

struct CheckersPiece: Codable, Equatable, Identifiable {
	let isLight: Bool
	let id: UUID
	var kinged: Bool
	
	init(isLight: Bool, id: UUID = UUID(), kinged: Bool = false) {
		self.isLight = isLight
		self.id = id
		self.kinged = kinged
	}
}
