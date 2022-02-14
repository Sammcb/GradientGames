//
//  ReversiBoard.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

let ReversiSizeRange = 1...8

typealias ReversiPieces = [ReversiPiece?]
extension ReversiPieces {
	subscript(column: Int, row: Int) -> Element {
		get {
			self[(column - 1) * 8 + row - 1]
		}
		
		set(newValue) {
			self[(column - 1) * 8 + row - 1] = newValue
		}
	}
	
	subscript(square: ReversiSquare) -> Element {
		get {
			self[square.column, square.row]
		}
		
		set(newValue) {
			self[square.column, square.row] = newValue
		}
	}
	
	static func square(at index: Int) -> ReversiSquare {
		ReversiSquare(column: index / 8 + 1, row: index % 8 + 1)
	}
}

struct ReversiBoard: Equatable {
	let maxMoves = 32
	var history = ReversiState.history
	var pieces = ReversiState.pieces
	var lightTurn: Bool {
		!history.count.isMultiple(of: 2)
	}
	var gameOver: Bool {
		history.last?.skip ?? false && !canMove()
	}
	
	private func squaresFlanked(from square: ReversiSquare) -> [ReversiSquare] {
		var flankedSquares: [ReversiSquare] = []
		for deltaRow in [-1, 0, 1] {
			for deltaColumn in [-1, 0, 1] {
				if deltaRow == 0 && deltaColumn == 0 {
					continue
				}
				
				var checkSquare = ReversiSquare(square, deltaColumn: deltaColumn, deltaRow: deltaRow)
				
				guard let currentSquare = checkSquare, let piece = pieces[currentSquare], piece.isLight != lightTurn else {
					continue
				}
				
				var opponentSquares = [currentSquare]
				checkSquare = ReversiSquare(currentSquare, deltaColumn: deltaColumn, deltaRow: deltaRow)
				
				while let currentSquare = checkSquare, let piece = pieces[currentSquare] {
					guard piece.isLight != lightTurn else {
						flankedSquares.append(contentsOf: opponentSquares)
						break
					}
					
					opponentSquares.append(currentSquare)
					checkSquare = ReversiSquare(currentSquare, deltaColumn: deltaColumn, deltaRow: deltaRow)
				}
				opponentSquares = []
			}
		}
		
		return flankedSquares
	}
	
	func canPlace(at square: ReversiSquare) -> Bool {
		return pieces[square] == nil && !squaresFlanked(from: square).isEmpty
	}
	
	func canMove() -> Bool {
		var moves = 2
		for move in history {
			if !move.skip && move.piece.isLight == lightTurn {
				moves += 1
			}
		}
		if moves >= maxMoves {
			return false
		}
		
		for row in ReversiSizeRange {
			for column in ReversiSizeRange {
				let checkSquare = ReversiSquare(column: column, row: row)
				guard pieces[checkSquare] == nil else {
					continue
				}
				if canPlace(at: checkSquare) {
					return true
				}
			}
		}
		return false
	}
	
	mutating func flank(_ flankedSquares: [ReversiSquare]) {
		for square in flankedSquares {
			pieces[square] = ReversiPiece(isLight: !pieces[square]!.isLight)
		}
	}
	
	mutating func place(at square: ReversiSquare) {
		let piece = ReversiPiece(isLight: lightTurn)
		let move: ReversiMove
		
		pieces[square] = piece
		let flankedSquares = squaresFlanked(from: square)
		flank(flankedSquares)
		move = ReversiMove(piece: piece, at: square, flanking: flankedSquares)
		
		history.append(move)
		
		ReversiState.history = history
		ReversiState.pieces = pieces
		
		if canMove() {
			return
		}
		
		skipMove()
	}
	
	mutating func skipMove() {
		history.append(ReversiMove(skip: true))
		
		ReversiState.history = history
	}
	
	mutating func undo() {
		if history.isEmpty {
			return
		}
		
		var move = history.removeLast()
		
		if move.skip {
			move = history.removeLast()
		}
		
		pieces[move.square] = nil
		flank(move.flankedSquares)
		
		ReversiState.history = history
		ReversiState.pieces = pieces
	}
}
