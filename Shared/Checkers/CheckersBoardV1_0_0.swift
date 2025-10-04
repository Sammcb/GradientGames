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
		// This has to be var with Swift 6 but could be a let
		var id = UUID()
		
		private var startingPieces: Checkers.Pieces = []
		private(set) var history: [Checkers.Move] = []
		@Transient private let maxTime = 3600.0
		var times = Times(light: 0, dark: 0, lastUpdate: Date())
		
		// Can this be @Transient? Currently that makes it unobservable
		@Attribute(.ephemeral) var selectedSquare: Checkers.Square?
		var validSquares: [Checkers.Square] {
			guard let selectedSquare else {
				return []
			}
			return validMoveSquares(from: selectedSquare, for: pieces)
		}
		
		var pieces: Checkers.Pieces {
			computeState(for: history, from: startingPieces)
		}
		
		var lightTurn: Bool {
			let darkTurn = history.filter({ move in !move.continued }).count.isMultiple(of: 2)
			return !darkTurn
		}
		
		var continuing: Bool {
			guard let move = history.last else {
				return false
			}
			return move.continued
		}
		
		var undoEnabled: Bool {
			!history.isEmpty
		}
		
		var gameOver: Bool {
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
		
		var forcedSelectedSquare: Checkers.Square? {
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
		
		func incrementTime(at currentDate: Date, isLight: Bool) {
			let interval = times.lastUpdate.distance(to: currentDate)
			
			guard interval > 0 else {
				return
			}
			
			if isLight {
				times.light += interval
				times.light.formTruncatingRemainder(dividingBy: maxTime)
			} else {
				times.dark += interval
				times.dark.formTruncatingRemainder(dividingBy: maxTime)
			}
			
			times.lastUpdate = currentDate
		}
	}
}
