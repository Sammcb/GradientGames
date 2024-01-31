//
//  ChessPromoteView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessPromoteView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoard
	var flipped: Bool
	let vertical: Bool
	private let groups: [Chess.Piece.Group] = [.knight, .bishop, .rook, .queen]
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		layout {
			ForEach(groups) { group in
				let piece = switch group {
				case .pawn: board.lightTurn ? "♙" : "♟︎"
				case .knight: board.lightTurn ? "♘" : "♞"
				case .bishop: board.lightTurn ? "♗" : "♝"
				case .rook: board.lightTurn ? "♖" : "♜"
				case .queen: board.lightTurn ? "♕" : "♛"
				case .king: board.lightTurn ? "♔" : "♚"
				}
				Button {
					board.promote(to: group)
				} label: {
					Text(piece)
						.font(.largeTitle)
				}
				.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
				.padding()
				.disabled(!board.promoting)
			}
		}
		.padding()
		.background(.ultraThinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 10))
#if os(tvOS)
		.focusSection()
#endif
	}
}
