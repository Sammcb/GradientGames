//
//  ReversiSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiSquareView: View {
	@Environment(\.reversiTheme) private var theme
	@EnvironmentObject private var game: ReversiGame
	let column: Int
	let row: Int
	
	var body: some View {
		let square = ReversiSquare(column: column, row: row)
		Button {
			guard game.board.canPlace(at: square) else {
				return
			}
			
			game.board.place(at: square)
		} label: {
			if let piece = game.board.pieces[square] {
				ReversiPieceView(isLight: piece.isLight)
					.scaleEffect(0.5)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.transition(.opacity.animation(.linear))
					.animation(.linear, value: game.board)
			} else {
				Text("")
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			
		}
		.background(theme.square, in: Rectangle())
#if os(tvOS)
		.buttonStyle(NoneButtonStyle())
#else
		.disabled(game.board.gameOver || game.board.pieces[square] != nil)
		.buttonStyle(.borderless)
#endif
	}
}
