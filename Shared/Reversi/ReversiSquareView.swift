//
//  ReversiSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiSquareView: View {
	@Environment(\.reversiTheme) private var theme
	var board: ReversiBoard
	let column: Int
	let row: Int
	
	var body: some View {
		let square = Reversi.Square(column: column, row: row)
		Button {
			guard board.canPlace(at: square) else {
				return
			}
			
			board.place(at: square)
		} label: {
			if let piece = board.pieces[square] {
				ReversiPieceView(isLight: piece.isLight)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.scaleEffect(0.5)
					.transition(.opacity.animation(.linear))
					.animation(.linear, value: board.history)
			} else {
				Text("")
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			
		}
		.background(theme.square, in: Rectangle())
		.overlay {
			if board.validSquares.contains(square) {
				Circle()
					.fill(board.lightTurn ? theme.pieceLight : theme.pieceDark)
					.scaleEffect(0.25)
					.transition(.opacity.animation(.linear))
			}
		}
#if os(tvOS)
		.buttonStyle(NoneButtonStyle())
#else
		.disabled(board.gameOver || board.pieces[square] != nil)
		.buttonStyle(.borderless)
#endif
	}
}
