//
//  ChessPieceView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessPieceView: View {
	@Environment(\.chessTheme) private var theme
	let group: Chess.Piece.Group
	let isLight: Bool
	
	init(piece: Chess.Piece) {
		self.init(group: piece.group, isLight: piece.isLight)
	}
	
	init(group: Chess.Piece.Group, isLight: Bool) {
		self.group = group
		self.isLight = isLight
	}
	
	var body: some View {
		let piece = switch group {
		case .pawn: isLight ? "♙" : "♟︎"
		case .knight: isLight ? "♘" : "♞"
		case .bishop: isLight ? "♗" : "♝"
		case .rook: isLight ? "♖" : "♜"
		case .queen: isLight ? "♕" : "♛"
		case .king: isLight ? "♔" : "♚"
		}
		GeometryReader { geometry in
			Text(piece)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.font(.system(size: geometry.size.width * 0.75))
				.foregroundStyle(isLight ? theme.pieceLight : theme.pieceDark)
		}
	}
}
