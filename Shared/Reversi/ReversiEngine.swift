//
//  ReversiEngine.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/15/24.
//

import Foundation

protocol ReversiEngine {}

extension ReversiEngine {
	private func flankedLineFrom(_ square: Reversi.Square, with columnStep: Int, _ rowStep: Int, for lightTurn: Bool, _ state: Reversi.Pieces) -> [Reversi.Square] {
		var flankedSquares: [Reversi.Square] = []
		let upperBound = Reversi.SizeRange.upperBound
		for delta in 1..<upperBound {
			// Edge of the board was hit before finding a friendly piece
			guard let flankedSquare = Reversi.Square(square, deltaColumn: delta * columnStep, deltaRow: delta * rowStep) else {
				return []
			}
			
			// Line does not end with a friendly piece
			guard let piece = state[flankedSquare] else {
				return []
			}
			
			// Opponent piece might be flanked
			guard piece.isLight == lightTurn else {
				flankedSquares.append(flankedSquare)
				continue
			}

			// Line ends with a friendly piece
			return flankedSquares
		}
		return []
	}
	
	private func squaresFlanked(from square: Reversi.Square, for lightTurn: Bool, _ state: Reversi.Pieces) -> [Reversi.Square] {
		let diagonalSteps = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
		let straightSteps = [(1, 0), (-1, 0), (0, 1), (0, -1)]
		let steps = diagonalSteps + straightSteps
		return steps.flatMap({ columnStep, rowStep in flankedLineFrom(square, with: columnStep, rowStep, for: lightTurn, state) })
	}
	
	func canPlace(at square: Reversi.Square, for lightTurn: Bool, _ state: Reversi.Pieces) -> Bool {
		state[square] == nil && !squaresFlanked(from: square, for: lightTurn, state).isEmpty
	}
	
	func allValidSquares(for lightTurn: Bool, _ state: Reversi.Pieces) -> [Reversi.Square] {
		var validSquares: [Reversi.Square] = []
		
		for index in 0..<state.count {
			let square = Reversi.Pieces.square(at: index)
			guard canPlace(at: square, for: lightTurn, state) else {
				continue
			}
			
			validSquares.append(square)
		}
		
		return validSquares
	}
	
	func canMove(for lightTurn: Bool, _ state: Reversi.Pieces, _ moves: [Reversi.Move], with maxMoves: Int) -> Bool {
		// Board start with 2 pieces already played
		let initialMoves = 2
		let movesMade = moves.filter({ move in move.light == lightTurn && !move.skip }).count
		
		guard initialMoves + movesMade < maxMoves else {
			return false
		}
		
		return !allValidSquares(for: lightTurn, state).isEmpty
	}
	
	func computeState(for moves: [Reversi.Move], from state: Reversi.Pieces) -> Reversi.Pieces {
		var pieces = state
		
		for move in moves {
			if move.skip {
				continue
			}
			
			// Place piece
			pieces[move.square] = Reversi.Piece(isLight: move.light)
			
			// Flank opponent pieces
			let flankedSquares = squaresFlanked(from: move.square, for: move.light, pieces)
			for flankedSquare in flankedSquares {
				guard let piece = pieces[flankedSquare] else {
					continue
				}
				
				pieces[flankedSquare] = Reversi.Piece(isLight: move.light, id: piece.id)
			}
		}
		
		return pieces
	}
}
