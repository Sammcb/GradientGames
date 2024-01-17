//
//  Checkers.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/15/24.
//

import Foundation

struct Checkers {
	private init() {}
	
	static var startingPieces: Pieces {
		var pieces = Pieces(repeating: nil, count: SizeRange.count * SizeRange.count)
		
		let darkRows = SizeRange.lowerBound...SizeRange.lowerBound + 2
		let darkSquares = darkRows.flatMap({ row in SizeRange.compactMap({ column in (column + row).isMultiple(of: 2) ? (column, row) : nil }) })
		darkSquares.forEach({ column, row in pieces[column, row] = Piece(isLight: false) })
		
		let lightRows = SizeRange.upperBound - 2...SizeRange.upperBound
		let lightSquares = lightRows.flatMap({ row in SizeRange.compactMap({ column in (column + row).isMultiple(of: 2) ? (column, row) : nil }) })
		lightSquares.forEach({ column, row in pieces[column, row] = Piece(isLight: true) })
		
		return pieces
	}
	
	static let SizeRange = 1...8

	typealias SquareDelta = (column: Int, row: Int)
	typealias Pieces = [Piece?]
}

extension Checkers.Pieces {
	subscript(column: Int, row: Int) -> Element {
		get {
			self[(column - 1) * 8 + row - 1]
		}
		
		set(newValue) {
			self[(column - 1) * 8 + row - 1] = newValue
		}
	}
	
	subscript(square: Checkers.Square) -> Element {
		get {
			self[square.column, square.row]
		}
		
		set(newValue) {
			self[square.column, square.row] = newValue
		}
	}
	
	static func square(at index: Int) -> Checkers.Square {
		Checkers.Square(column: index / 8 + 1, row: index % 8 + 1)
	}
}
