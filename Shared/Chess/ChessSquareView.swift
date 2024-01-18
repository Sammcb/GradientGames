//
//  ChessSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessSquareView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoard
	let file: Chess.File
	let rank: Int
	
	private func select(square: Chess.Square) {
		if board.gameOver {
			return
		}
		
		if let piece = board.pieces[square], piece.isLight == board.lightTurn {
			board.selectedSquare = square
			return
		}
		
		guard let selectedSquare = board.selectedSquare, board.canMove(from: selectedSquare, to: square) else {
			return
		}
		
		board.move(from: selectedSquare, to: square)
	}
	
	var body: some View {
		let square = Chess.Square(file: file, rank: rank)
		let lightSquare = (rank + file.rawValue - 1).isMultiple(of: 2)
		Button {
			select(square: square)
		} label: {
			lightSquare ? theme.squareLight : theme.squareDark
		}
		.buttonStyle(.borderless)
		.disabled(board.promoting || board.selectedSquare == square)
		.overlay {
			if board.validSquares.contains(square) {
				Circle()
					.fill(board.lightTurn ? theme.pieceLight : theme.pieceDark)
					.scaleEffect(0.25)
					.transition(.opacity.animation(.easeOut))
			}
		}
	}
}
