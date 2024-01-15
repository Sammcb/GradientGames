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
//			Spacer()
			ForEach(groups) { group in
				Button {
					board.promote(to: group)
				} label: {
					ChessPieceView(group: group, isLight: board.lightTurn)
						.font(.system(size: 60))
				}
				.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
				
//				Spacer()
			}
		}
		.disabled(!board.promoting)
		.animation(.easeIn, value: board.lightTurn)
		.padding()
		.background(.ultraThinMaterial)
#if os(tvOS)
		.focusSection()
#endif
		.transition(.opacity.animation(.linear))
	}
}
