//
//  ReversiSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiSquareView: View {
	@Environment(\.reversiTheme) private var theme
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
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
			Color(theme.colors[.squares])
				.animation(.easeInOut(duration: 0.6), value: board.history)
		}
		.accessibilityIdentifier("Row\(row)Column\(column)ReversiBoardSquareButton")
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
