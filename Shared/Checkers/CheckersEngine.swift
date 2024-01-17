//
//  CheckersEngine.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/15/24.
//

import Foundation

protocol CheckersEngine {}

extension CheckersEngine {
	private func capturedSquare(from oldSquare: Checkers.Square, to newSquare: Checkers.Square, for state: Checkers.Pieces) -> Checkers.Square? {
		let squareDelta = oldSquare.delta(to: newSquare)
		let columnOffset = squareDelta.column.signum()
		let rowOffset = squareDelta.row.signum()
		return Checkers.Square(oldSquare, deltaColumn: squareDelta.column - columnOffset, deltaRow: squareDelta.row - rowOffset)
	}
	
	func moveCaptures(from oldSquare: Checkers.Square, to newSquare: Checkers.Square, for state: Checkers.Pieces) -> Bool {
		// Move must jump a row/column and earlier checks confirm squares are diagonal from each other
		guard oldSquare.rowDistance(to: newSquare) > 1 else {
			return false
		}
		
		guard let capturedSquare = capturedSquare(from: oldSquare, to: newSquare, for: state) else {
			return false
		}
		
		guard let checkPiece = state[capturedSquare] else {
			return false
		}
		
		guard let piece = state[oldSquare] else {
			return false
		}

		return checkPiece.isLight != piece.isLight
	}
	
	private func rowRange(for piece: Checkers.Piece) -> ClosedRange<Int> {
		let maxRange = 2
		let offset = piece.isLight ? -maxRange : maxRange
		let rowRangeLowerBound = piece.kinged ? -maxRange : min(0, offset)
		let rowRangeUpperBound = piece.kinged ? maxRange : max(0, offset)
		return rowRangeLowerBound...rowRangeUpperBound
	}
	
	private func canMove(from oldSquare: Checkers.Square, to newSquare: Checkers.Square, for state: Checkers.Pieces) -> Bool {
		guard let piece = state[oldSquare], state[newSquare] == nil else {
			return false
		}
		
		let squareDelta = oldSquare.delta(to: newSquare)
		
		// Can only move on diagonals
		guard abs(squareDelta.column) == abs(squareDelta.row) else {
			return false
		}
		
		let rowRange = rowRange(for: piece)
		guard rowRange.contains(squareDelta.row) else {
			return false
		}
		
		guard oldSquare.rowDistance(to: newSquare) > 1 else {
			return true
		}
		
		return moveCaptures(from: oldSquare, to: newSquare, for: state)
	}
	
	private func moveSquares(from oldSquare: Checkers.Square, for state: Checkers.Pieces) -> [Checkers.Square] {
		guard let piece = state[oldSquare] else {
			return []
		}
		
		let rowRange = rowRange(for: piece)
		let columnRange = -2...2
		let diagonals = columnRange.flatMap({ column in rowRange.compactMap({ row in abs(column) == abs(row) ? (column, row) : nil }) })
		let toSquares = diagonals.filter({ _, row in row != 0 }).compactMap({ column, row in Checkers.Square(oldSquare, deltaColumn: column, deltaRow: row) })
		return toSquares.filter({ square in canMove(from: oldSquare, to: square, for: state) })
	}
	
	private func filterNonCaptures(from toSquares: [Checkers.Square], for oldSquare: Checkers.Square, _ state: Checkers.Pieces) -> [Checkers.Square] {
		toSquares.filter({ square in moveCaptures(from: oldSquare, to: square, for: state) })
	}
	
	func hasAvaliableCaptures(from oldSquare: Checkers.Square, for state: Checkers.Pieces) -> Bool {
		let moveSquares = moveSquares(from: oldSquare, for: state)
		return !filterNonCaptures(from: moveSquares, for: oldSquare, state).isEmpty
	}
	
	private func hasAvailableCaptures(for lightTurn: Bool, _ state: Checkers.Pieces) -> Bool {
		for (index, piece) in state.enumerated() {
			guard let piece, piece.isLight == lightTurn else {
				continue
			}
			
			let square = Checkers.Pieces.square(at: index)
			guard hasAvaliableCaptures(from: square, for: state) else {
				continue
			}
			return true
		}
		return false
	}
	
	func validMoveSquares(from oldSquare: Checkers.Square, for state: Checkers.Pieces) -> [Checkers.Square] {
		guard let piece = state[oldSquare] else {
			return []
		}
		
		// If a capture is available, it must be taken
		let hasAvailableCaptures = hasAvailableCaptures(for: piece.isLight, state)
		let moveSquares = moveSquares(from: oldSquare, for: state)
		return hasAvailableCaptures ? filterNonCaptures(from: moveSquares, for: oldSquare, state) : moveSquares
	}
	
	func validMove(from oldSquare: Checkers.Square, to newSquare: Checkers.Square, for state: Checkers.Pieces) -> Bool {
		validMoveSquares(from: oldSquare, for: state).contains(newSquare)
	}
	
	func hasValidSquares(for lightTurn: Bool, _ state: Checkers.Pieces) -> Bool {
		
		for (index, piece) in state.enumerated() {
			guard let piece, piece.isLight == lightTurn else {
				continue
			}
			
			let square = Checkers.Pieces.square(at: index)
			let validSquares = validMoveSquares(from: square, for: state)
			if validSquares.isEmpty {
				continue
			}
			return true
		}
		return false
	}
	
	func kingRow(for light: Bool) -> Int {
		light ? Checkers.SizeRange.lowerBound : Checkers.SizeRange.upperBound
	}
	
	func computeState(for moves: [Checkers.Move], from state: Checkers.Pieces) -> Checkers.Pieces {
		var pieces = state
		
		for move in moves {
			guard var piece = pieces[move.fromSquare] else {
				continue
			}
			
			let kingRow = kingRow(for: piece.isLight)
			if !piece.kinged && move.toSquare.row == kingRow {
				piece.kinged = true
			}
			
			let pastState = pieces
			pieces[move.toSquare] = piece
			pieces[move.fromSquare] = nil
			
			guard moveCaptures(from: move.fromSquare, to: move.toSquare, for: pastState) else {
				continue
			}
			
			guard let capturedSquare = capturedSquare(from: move.fromSquare, to: move.toSquare, for: pastState) else {
				continue
			}
			
			pieces[capturedSquare] = nil
		}
		
		return pieces
	}
}
