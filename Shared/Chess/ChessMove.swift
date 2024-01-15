//
//  ChessMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Chess {
	struct Move: Codable, Equatable {
		let piece: Chess.Piece
		let fromSquare: Chess.Square
		let toSquare: Chess.Square
		let capturedPiece: Chess.Piece?
		let capturedSquare: Chess.Square?
		let promoted: Bool
		var promotedPiece: Chess.Piece?
		
		init(piece: Chess.Piece, from oldSquare: Chess.Square, to square: Chess.Square, captured capturedPiece: Chess.Piece?, at capturedSquare: Chess.Square, promoted: Bool = false) {
			self.piece = piece
			self.fromSquare = oldSquare
			self.toSquare = square
			self.capturedPiece = capturedPiece
			self.capturedSquare = capturedPiece == nil ? nil : capturedSquare
			self.promoted = promoted
		}
	}
}
