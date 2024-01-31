//
//  CheckersBoardV1_0_0.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/27/24.
//

import Foundation
import SwiftData

extension SchemaV1_0_0 {
	@Model
	final class CheckersBoard: CheckersEngine {
		let id = UUID()
		
		private var startingPieces: Checkers.Pieces = []
		private (set) var history: [Checkers.Move] = []
		var times = Times(light: 0, dark: 0, lastUpdate: Date())
		
		// Can this be @Transient? Currently that makes it unobservable
		@Attribute(.ephemeral) var selectedSquare: Checkers.Square?
		@Transient var validSquares: [Checkers.Square] {
			guard let selectedSquare else {
				return []
			}
			return validMoveSquares(from: selectedSquare, for: pieces)
		}
		
		@Transient var pieces: Checkers.Pieces {
			computeState(for: history, from: startingPieces)
		}
		
		@Transient var lightTurn: Bool {
			let darkTurn = history.filter({ move in !move.continued }).count.isMultiple(of: 2)
			return !darkTurn
		}
		
		@Transient var continuing: Bool {
			guard let move = history.last else {
				return false
			}
			return move.continued
		}
		
		@Transient var undoEnabled: Bool {
			!history.isEmpty
		}
		
		@Transient var gameOver: Bool {
			!hasValidSquares(for: lightTurn, pieces)
		}
		
		init() {
			self.startingPieces = Checkers.startingPieces
		}
		
		func canMove(from oldSquare: Checkers.Square, to newSquare: Checkers.Square) -> Bool {
			validMove(from: oldSquare, to: newSquare, for: pieces)
		}
		
		func move(from oldSquare: Checkers.Square, to newSquare: Checkers.Square) {
			guard let piece = pieces[oldSquare] else {
				return
			}
			
			let kingedRow = kingRow(for: piece.isLight)
			let kinged = !piece.kinged && newSquare.row == kingedRow
			let captured = moveCaptures(from: oldSquare, to: newSquare, for: pieces)
			
			var move = Checkers.Move(from: oldSquare, to: newSquare)
			let futurePieces = computeState(for: [move], from: pieces)
			
			let hasFutureCaptures = hasAvaliableCaptures(from: newSquare, for: futurePieces)
			move.continued = captured && !kinged && hasFutureCaptures
			history.append(move)
		}
		
		@Transient var forcedSelectedSquare: Checkers.Square? {
			guard let lastMove = history.last, lastMove.continued else {
				return nil
			}
			return lastMove.toSquare
		}
		
		func undo() {
			guard undoEnabled else {
				return
			}
			
			let _ = history.popLast()
			selectedSquare = forcedSelectedSquare
		}
	}
}