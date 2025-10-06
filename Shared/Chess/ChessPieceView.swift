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
				.font(.system(size: geometry.size.width * 0.75))
				.foregroundStyle(isLight ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}
