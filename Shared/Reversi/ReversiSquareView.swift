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
			if board.gameOver {
				return
			}
			
			guard board.canPlace(at: square) else {
				return
			}
			
			board.place(at: square)
		} label: {
			Rectangle()
				.fill(theme.square)
		}
		.buttonStyle(.borderless)
		.overlay {
			if board.validSquares.contains(square) {
				Circle()
					.fill(board.lightTurn ? theme.pieceLight : theme.pieceDark)
					.scaleEffect(0.25)
					.transition(.opacity.animation(.linear))
			}
		}
	}
}
