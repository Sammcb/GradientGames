//
//  ReversiBoardV1_0_0.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/27/24.
//

import Foundation
import SwiftData

extension SchemaV1_0_0 {
	@Model
	final class ReversiBoard: ReversiEngine {
		let id = UUID()
		
		private var startingPieces: Reversi.Pieces = []
		private (set) var history: [Reversi.Move] = []
		var times = Times(light: 0, dark: 0, lastUpdate: Date())
		
		@Transient let maxMoves = 32
		
		@Transient var pieces: Reversi.Pieces {
			computeState(for: history, from: startingPieces)
		}
		
		@Transient var lightTurn: Bool {
			!history.count.isMultiple(of: 2)
		}
		
		@Transient var gameOver: Bool {
			// If last player was skipped and current player cannot move, then last player will never be able to move
			history.last?.skip ?? false && !canMove(for: lightTurn, pieces, history, with: maxMoves)
		}
		
		@Transient var undoEnabled: Bool {
			!history.isEmpty
		}
		
		@Transient var validSquares: [Reversi.Square] {
			allValidSquares(for: lightTurn, pieces)
		}
		
		init() {
			self.startingPieces = Reversi.startingPieces
		}
		
		func canPlace(at square: Reversi.Square) -> Bool {
			canPlace(at: square, for: lightTurn, pieces)
		}
		
		func place(at square: Reversi.Square) {
			let piece = Reversi.Piece(isLight: lightTurn)
			
			
			let move = Reversi.Move(light: piece.isLight, at: square)
			let futureMoves = history + [move]
			let futurePieces = computeState(for: [move], from: pieces)
			let nextPlayerCanMove = canMove(for: !lightTurn, futurePieces, futureMoves, with: maxMoves)
			
			history.append(move)
			
			if nextPlayerCanMove {
				return
			}
			
			let skipMove = Reversi.Move(skip: true)
			history.append(skipMove)
		}
		
		func undo() {
			guard undoEnabled else {
				return
			}
			
			guard let move = history.popLast(), move.skip else {
				return
			}
			
			let _ = history.popLast()
		}
	}
}