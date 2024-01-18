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
		if board.gameOver {
			return
		}
		
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
		let lightSquare = (row + column - 1).isMultiple(of: 2)
		Button {
			select(square: square)
		} label: {
			Rectangle()
				.fill(lightSquare ? theme.squareLight : theme.squareDark)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
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
