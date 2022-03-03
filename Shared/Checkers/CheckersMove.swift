//
//  CheckersMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

struct CheckersMove: Codable, Equatable {
	let piece: CheckersPiece
	let fromSquare: CheckersSquare
	let toSquare: CheckersSquare
	var kinged: Bool
	var capturedPiece: CheckersPiece?
	let skip: Bool
	
	init(piece: CheckersPiece, from oldSquare: CheckersSquare, to square: CheckersSquare, kinged: Bool) {
		self.piece = piece
		self.fromSquare = oldSquare
		self.toSquare = square
		self.kinged = kinged
		self.skip = false
	}
	
	init(piece: CheckersPiece, from oldSquare: CheckersSquare, to square: CheckersSquare, kinged: Bool, captured capturedPieces: CheckersPiece?) {
		self.piece = piece
		self.fromSquare = oldSquare
		self.toSquare = square
		self.kinged = kinged
		self.capturedPiece = capturedPieces
		self.skip = false
	}
	
	init(to square: CheckersSquare, skip: Bool) {
		self.piece = CheckersPiece(isLight: true)
		self.fromSquare = CheckersSquare(column: 1, row: 1)
		self.toSquare = square
		self.kinged = false
		self.skip = skip
	}
}
