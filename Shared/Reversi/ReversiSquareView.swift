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
	var showMoves: Bool
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
			theme.colors[.squares]
		}
		.buttonStyle(.borderless)
		.overlay {
			if showMoves && board.validSquares.contains(square) {
				Circle()
					.fill(board.lightTurn ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
					.scaleEffect(0.25)
					.transition(.scale.animation(.easeOut))
					.animation(.easeIn, value: board.lightTurn)
					.allowsHitTesting(false)
			}
		}
	}
}
