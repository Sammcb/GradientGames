//
//  CheckersBoard.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

let CheckersSizeRange = 1...8

typealias CheckersPieces = [CheckersPiece?]
extension CheckersPieces {
	subscript(column: Int, row: Int) -> Element {
		get {
			self[(column - 1) * 8 + row - 1]
		}
		
		set(newValue) {
			self[(column - 1) * 8 + row - 1] = newValue
		}
	}
	
	subscript(square: CheckersSquare) -> Element {
		get {
			self[square.column, square.row]
		}
		
		set(newValue) {
			self[square.column, square.row] = newValue
		}
	}
	
	static func square(at index: Int) -> CheckersSquare {
		CheckersSquare(column: index / 8 + 1, row: index % 8 + 1)
	}
}

struct CheckersBoard: Equatable {
	var history = CheckersState.shared.history
	var pieces = CheckersState.shared.pieces
	var lightTurn: Bool {
		!history.count.isMultiple(of: 2)
	}
	var gameOver: Bool {
		let deltas = [(-1, 1), (-1, -1), (-2, 2), (-2, -2), (1, 1), (1, -1), (2, 2), (2, -2)]
		
		for (i, piece) in pieces.enumerated() {
			guard let piece, piece.isLight == lightTurn else {
				continue
			}
			
			let square = CheckersPieces.square(at: i)
			for delta in deltas {
				guard let checkSquare = CheckersSquare(square, deltaColumn: delta.0, deltaRow: delta.1) else {
					continue
				}
				
				if canMove(from: square, to: checkSquare) {
					return false
				}
			}
		}
		return true
	}
	
	private func moveCaptures(with piece: CheckersPiece, from oldSquare: CheckersSquare, to square: CheckersSquare) -> CheckersPiece? {
		let checkSquare = CheckersSquare(oldSquare, deltaColumn: (square.column - oldSquare.column) / 2, deltaRow: (square.row - oldSquare.row) / 2)
		guard let checkSquare else {
			return nil
		}
		
		guard let checkPiece = pieces[checkSquare] else {
			return nil
		}

		return checkPiece.isLight == piece.isLight ? nil : checkPiece
	}
	
	private func moreCaptures(with piece: CheckersPiece, at square: CheckersSquare) -> Bool {
		for delta in [(-2, -2), (2, -2), (-2, 2), (2, 2)] {
			guard piece.kinged || (delta.1 < 0 && piece.isLight) || (delta.1 > 0 && !piece.isLight) else {
				continue
			}
			
			guard let checkSquare = CheckersSquare(square, deltaColumn: delta.0 / 2, deltaRow: delta.1 / 2), let checkPiece = pieces[checkSquare] else {
				continue
			}
			
			guard let toSquare = CheckersSquare(square, deltaColumn: delta.0, deltaRow: delta.1), pieces[toSquare] == nil else {
				continue
			}

			if checkPiece.isLight != piece.isLight {
				return true
			}
		}
		
		return false
	}
	
	private mutating func movePiece(_ piece: CheckersPiece, to square: CheckersSquare) {
		pieces[square] = piece
	}
	
	private mutating func movePiece(at oldSquare: CheckersSquare, to square: CheckersSquare) {
		pieces[square] = pieces[oldSquare]
		capture(at: oldSquare)
	}
	
	private mutating func capture(at square: CheckersSquare) {
		pieces[square] = nil
	}
	
	func canMove(from oldSquare: CheckersSquare, to square: CheckersSquare) -> Bool {
		guard let piece = pieces[oldSquare] else {
			return false
		}
		
		guard pieces[square] == nil else {
			return false
		}
		
		for delta in [(-1, 1), (-1, -1), (-2, 2), (-2, -2), (1, 1), (1, -1), (2, 2), (2, -2)] {
			guard piece.kinged || (delta.1 < 0 && piece.isLight) || (delta.1 > 0 && !piece.isLight) else {
				continue
			}
			
			guard CheckersSquare(oldSquare, deltaColumn: delta.0, deltaRow: delta.1) == square else {
				continue
			}
			
			if !(-1...1).contains(delta.0) {
				return moveCaptures(with: piece, from: oldSquare, to: square) != nil
			} else if let lastMove = history.last, lastMove.skip {
				return false
			} else {
				return true
			}
		}
		
		return false
	}
	
	mutating func move(from oldSquare: CheckersSquare, to square: CheckersSquare) {
		let piece = pieces[oldSquare]!
		var move: CheckersMove
		
		let kingRow = piece.isLight ? 1 : 8
		let kinged = !piece.kinged && square.row == kingRow
		
		if (-1...1).contains(square.row - oldSquare.row) {
			move = CheckersMove(piece: piece, from: oldSquare, to: square, kinged: kinged)
		} else {
			let captured = moveCaptures(with: piece, from: oldSquare, to: square)!
			let capturedIndex = pieces.firstIndex(of: captured)!
			let capturedSquare = CheckersPieces.square(at: capturedIndex)
			move = CheckersMove(piece: piece, from: oldSquare, to: square, kinged: kinged, captured: captured)
			capture(at: capturedSquare)
			if moreCaptures(with: piece, at: square) {
				history.append(move)
				move = CheckersMove(to: square, skip: true)
			}
		}
		
		if kinged {
			pieces[oldSquare]!.kinged = true
		}
		
		movePiece(at: oldSquare, to: square)
		history.append(move)
		
		CheckersState.shared.history = history
		CheckersState.shared.pieces = pieces
	}
	
	mutating func undo() {
		if history.isEmpty {
			return
		}
		
		var move = history.removeLast()
		
		if move.skip {
			move = history.removeLast()
		}
		
		if let capturedPiece = move.capturedPiece {
			let capturedSquare = CheckersSquare(move.fromSquare, deltaColumn: (move.toSquare.column - move.fromSquare.column) / 2, deltaRow: (move.toSquare.row - move.fromSquare.row) / 2)!
			movePiece(capturedPiece, to: capturedSquare)
		}
		
		movePiece(at: move.toSquare, to: move.fromSquare)
		
		if move.kinged {
			pieces[move.fromSquare]!.kinged = false
		}
		
		CheckersState.shared.history = history
		CheckersState.shared.pieces = pieces
	}
}
