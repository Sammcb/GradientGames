//
//  ChessMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Chess {
	struct Move: Codable, Equatable {
		let fromSquare: Square
		let toSquare: Square
		let capturedSquare: Square?
		let promoted: Bool
		var promotedPiece: Piece?

		init(from oldSquare: Square, to square: Square, capturedAt capturedSquare: Square?, promoted: Bool) {
			self.fromSquare = oldSquare
			self.toSquare = square
			self.capturedSquare = capturedSquare
			self.promoted = promoted
		}
	}
}
