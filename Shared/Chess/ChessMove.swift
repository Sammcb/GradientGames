//
//  ChessMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

class ChessMove: Codable, Equatable {
	static func == (lhs: ChessMove, rhs: ChessMove) -> Bool {
		lhs.piece == rhs.piece && lhs.fromSquare == rhs.fromSquare && lhs.toSquare == rhs.toSquare && lhs.capturedSquare == rhs.capturedSquare && lhs.capturedPiece == rhs.capturedPiece && lhs.promoted == rhs.promoted && lhs.promotedPiece == rhs.promotedPiece
	}
	
	let piece: ChessPiece
	let fromSquare: ChessSquare
	let toSquare: ChessSquare
	let capturedPiece: ChessPiece?
	let capturedSquare: ChessSquare?
	let promoted: Bool
	var promotedPiece: ChessPiece?
	
	init(piece: ChessPiece, from oldSquare: ChessSquare, to square: ChessSquare) {
		self.piece = piece
		self.fromSquare = oldSquare
		self.toSquare = square
		self.capturedPiece = nil
		self.capturedSquare = nil
		self.promoted = false
	}
	
	init(piece: ChessPiece, from oldSquare: ChessSquare, to square: ChessSquare, captured capturedPiece: ChessPiece, at capturedSquare: ChessSquare) {
		self.piece = piece
		self.fromSquare = oldSquare
		self.toSquare = square
		self.capturedPiece = capturedPiece
		self.capturedSquare = capturedSquare
		self.promoted = false
	}
	
	init(piece: ChessPiece, from oldSquare: ChessSquare, to square: ChessSquare, promoted: Bool = false) {
		self.piece = piece
		self.fromSquare = oldSquare
		self.toSquare = square
		self.capturedPiece = nil
		self.capturedSquare = nil
		self.promoted = promoted
	}
	
	init(piece: ChessPiece, from oldSquare: ChessSquare, to square: ChessSquare, captured capturedPiece: ChessPiece?, at capturedSquare: ChessSquare, promoted: Bool = false) {
		self.piece = piece
		self.fromSquare = oldSquare
		self.toSquare = square
		self.capturedPiece = capturedPiece
		self.capturedSquare = capturedPiece == nil ? nil : capturedSquare
		self.promoted = promoted
	}
}
