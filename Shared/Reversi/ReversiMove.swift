//
//  ReversiMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Reversi {
	struct Move: Codable, Equatable {
		let piece: Piece
		let square: Square
		let skip: Bool
		
		init(piece: Piece, at square: Square) {
			self.piece = piece
			self.square = square
			self.skip = false
		}
		
		init(skip: Bool) {
			self.piece = Piece(isLight: true)
			self.square = Square(column: 1, row: 1)
			self.skip = skip
		}
	}
}
