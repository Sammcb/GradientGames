//
//  ChessBoard.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/9/24.
//

import SwiftData

@Model
final class ChessBoardTest {
	static private var startingPieces: ChessPieces {
		var pieces = ChessPieces(repeating: nil, count: ChessFile.validFiles.count * ChessRanks.count)
		
		for rank in [1, 8] {
			pieces[.a, rank] = ChessPiece(isLight: rank == 1, group: .rook)
			pieces[.b, rank] = ChessPiece(isLight: rank == 1, group: .knight)
			pieces[.c, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
			pieces[.d, rank] = ChessPiece(isLight: rank == 1, group: .queen)
			pieces[.e, rank] = ChessPiece(isLight: rank == 1, group: .king)
			pieces[.f, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
			pieces[.g, rank] = ChessPiece(isLight: rank == 1, group: .knight)
			pieces[.h, rank] = ChessPiece(isLight: rank == 1, group: .rook)
		}
		
		for rank in [2, 7] {
			for file in ChessFile.validFiles {
				pieces[file, rank] = ChessPiece(isLight: rank == 2, group: .pawn)
			}
		}
		
		return pieces
	}
	
	var history: [ChessMove] = []
	var pieces: ChessPieces = startingPieces
	
	init() {}
}
