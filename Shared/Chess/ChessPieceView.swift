//
//  ChessPieceView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessPieceView: View {
	@Environment(\.chessTheme) private var theme
	let group: ChessPiece.Group
	let isLight: Bool
	private var piece: String {
		get {
			switch group {
			case .pawn:
				return isLight ? "♙" : "♟︎"
			case .knight:
				return isLight ? "♘" : "♞"
			case .bishop:
				return isLight ? "♗" : "♝"
			case .rook:
				return isLight ? "♖" : "♜"
			case .queen:
				return isLight ? "♕" : "♛"
			case .king:
				return isLight ? "♔" : "♚"
			}
		}
	}
	
	init(piece: ChessPiece) {
		self.init(group: piece.group, isLight: piece.isLight)
	}
	
	init(group: ChessPiece.Group, isLight: Bool) {
		self.group = group
		self.isLight = isLight
	}
	
	var body: some View {
		Text(piece)
			.foregroundStyle(isLight ? theme.pieceLight : theme.pieceDark)
	}
}
