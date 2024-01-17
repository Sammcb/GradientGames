//
//  CheckersSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersSquareView: View {
	@Environment(\.checkersTheme) private var theme
	var board: CheckersBoard
	let column: Int
	let row: Int
	
	private func select(square: Checkers.Square) {
		if let piece = board.pieces[square], piece.isLight == board.lightTurn, board.forcedSelectedSquare == nil {
			board.selectedSquare = square
			return
		}
		
		guard let selectedSquare = board.selectedSquare, board.canMove(from: selectedSquare, to: square) else {
			return
		}
		
		board.move(from: selectedSquare, to: square)
		board.selectedSquare = board.forcedSelectedSquare
	}
	
	var body: some View {
		let square = Checkers.Square(column: column, row: row)
		Button {
			select(square: square)
		} label: {
			// Needs to appear/disapper not use opacity
			GeometryReader { geometry in
				Circle()
					.stroke(board.lightTurn ? theme.pieceLight : theme.pieceDark, lineWidth: geometry.size.width / 10)
					.opacity(board.selectedSquare == square ? 1 : 0)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.scaledToFit()
					.scaleEffect(0.8)
			}
		}
#if os(tvOS)
		.buttonStyle(NoneButtonStyle())
#else
		.buttonStyle(.borderless)
		.disabled(board.gameOver)
#endif
		.background((row + column - 1).isMultiple(of: 2) ? theme.squareLight : theme.squareDark, in: Rectangle())
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
