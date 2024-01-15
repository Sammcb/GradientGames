//
//  ChessMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Chess {
	struct Move: Codable, Equatable {
		let piece: Piece
		let fromSquare: Square
		let toSquare: Square
		let capturedSquare: Square?
		let promoted: Bool
		var promotedPiece: Piece?
		
		init(piece: Piece, from oldSquare: Square, to square: Square, capturedAt capturedSquare: Square?, promoted: Bool) {
			self.piece = piece
			self.fromSquare = oldSquare
			self.toSquare = square
			self.capturedSquare = capturedSquare
			self.promoted = promoted
		}
	}
}
