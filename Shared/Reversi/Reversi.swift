//
//  Reversi.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/15/24.
//

import Foundation

struct Reversi {
	private init() {}
	
	static var startingPieces: Pieces {
		var pieces = Pieces(repeating: nil, count: SizeRange.count * SizeRange.count)
		
		pieces[4, 4] = Piece(isLight: false)
		pieces[5, 4] = Piece(isLight: true)
		pieces[5, 5] = Piece(isLight: false)
		pieces[4, 5] = Piece(isLight: true)
		
		return pieces
	}
	
	static let SizeRange = 1...8

	typealias Pieces = [Piece?]
}

extension Reversi.Pieces {
	subscript(column: Int, row: Int) -> Element {
		get {
			self[(column - 1) * 8 + row - 1]
		}
		
		set(newValue) {
			self[(column - 1) * 8 + row - 1] = newValue
		}
	}
	
	subscript(square: Reversi.Square) -> Element {
		get {
			self[square.column, square.row]
		}
		
		set(newValue) {
			self[square.column, square.row] = newValue
		}
	}
	
	static func square(at index: Int) -> Reversi.Square {
		Reversi.Square(column: index / 8 + 1, row: index % 8 + 1)
	}
}
