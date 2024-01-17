//
//  ChessBoard.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/9/24.
//

import Foundation
import SwiftData

@Model
class ChessBoard: ChessEngine {
	let id = UUID()
	
	private var startingPieces: Chess.Pieces = []
	private (set) var history: [Chess.Move] = []
	var times = Times(light: 0, dark: 0, lastUpdate: Date())
	
	// Can this be @Transient? Currently that makes it unobservable
	@Attribute(.ephemeral) var selectedSquare: Chess.Square?
	@Transient var validSquares: [Chess.Square] {
		guard let selectedSquare else {
			return []
		}
		return validMoveSquares(from: selectedSquare, for: lightTurn, pieces, history)
	}
	
	@Transient var pieces: Chess.Pieces {
		computeState(for: history, from: startingPieces)
	}
	
	@Transient var lightTurn: Bool {
		let lightTurn = history.count.isMultiple(of: 2)
		if promoting {
			return !lightTurn
		}
		
		return lightTurn
	}
	
	@Transient var promoting: Bool {
		guard let move = history.last else {
			return false
		}
		return move.promoted && move.promotedPiece == nil
	}
	
	@Transient var kingStates: Chess.KingStates {
		computeKingStates(for: lightTurn, pieces, history)
	}
	
	@Transient var undoEnabled: Bool {
		!history.isEmpty
	}
	
	@Transient var gameOver: Bool {
		let kingState = lightTurn ? kingStates.light : kingStates.dark
		return kingState == .checkmate || kingState == .stalemate
	}
	
	init() {
		self.startingPieces = Chess.startingPieces
	}
	
	func canMove(from oldSquare: Chess.Square, to newSquare: Chess.Square) -> Bool {
		canMove(from: oldSquare, to: newSquare, for: lightTurn, pieces, history)
	}

	func move(from oldSquare: Chess.Square, to square: Chess.Square) {
		guard let move = computeMove(from: oldSquare, to: square, for: pieces) else {
			return
		}

		selectedSquare = nil
		history.append(move)
	}
	
	func promote(to group: Chess.Piece.Group) {
		guard promoting, var move = history.popLast() else {
			return
		}
		
		guard let piece = pieces[move.toSquare] else {
			return
		}
		
		move.promotedPiece = Chess.Piece(isLight: lightTurn, group: group, id: piece.id)
		history.append(move)
	}
	
	func undo() {
		guard undoEnabled else {
			return
		}
		
		selectedSquare = nil
		let _ = history.popLast()
	}
}
