//
//  ReversiPiece.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Reversi {
	struct Piece: Codable, Equatable, Identifiable {
		let isLight: Bool
		let id: UUID
		
		init(isLight: Bool, id: UUID = UUID()) {
			self.isLight = isLight
			self.id = id
		}
	}
}
