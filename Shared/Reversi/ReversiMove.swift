//
//  ReversiMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct ReversiMove: Codable, Equatable {
	let piece: ReversiPiece
	let square: ReversiSquare
	let flankedSquares: [ReversiSquare]
	let skip: Bool
	
	init(piece: ReversiPiece, at square: ReversiSquare, flanking squares: [ReversiSquare]) {
		self.piece = piece
		self.square = square
		self.flankedSquares = squares
		self.skip = false
	}
	
	init(skip: Bool) {
		self.piece = ReversiPiece(isLight: true)
		self.square = ReversiSquare(column: 1, row: 1)
		self.flankedSquares = []
		self.skip = skip
	}
}
