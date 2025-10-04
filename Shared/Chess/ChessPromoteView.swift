//
//  ChessPromoteView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessPromoteView: View {
	@Environment(\.chessTheme) private var theme
	@Environment(\.verticalUI) private var verticalUI
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	var board: ChessBoard
	let lightTurn: Bool
	private let groups: [Chess.Piece.Group] = [.knight, .bishop, .rook, .queen]
	
	var body: some View {
		let layout = verticalUI ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		layout {
			ForEach(groups) { group in
				Button {
					board.promote(to: group)
				} label: {
					ChessPieceView(group: group, isLight: lightTurn)
						.aspectRatio(contentMode: .fit)
				}
				.padding()
				.disabled(!board.promoting)
			}
		}
		.rotationEffect(!lightTurn && flipUI ? .radians(.pi) : .zero)
		.glassEffect(.clear)
		.padding()
#if os(tvOS)
		.focusSection()
#endif
	}
}
