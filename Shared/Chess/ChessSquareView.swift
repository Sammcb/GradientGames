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
		Button {
			select(square: square)
		} label: {
			GeometryReader { geometry in
				Circle()
					.stroke(board.lightTurn ? theme.pieceLight : theme.pieceDark, lineWidth: geometry.size.width / 10)
					.opacity(board.selectedSquare == square ? 1 : 0)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.scaledToFit()
					.scaleEffect(x: 0.8, y: 0.8)
			}
		}
#if os(tvOS)
		.buttonStyle(NoneButtonStyle())
		.disabled(board.promoting || selected == square)
#else
		.buttonStyle(.borderless)
		.disabled(board.gameOver || board.promoting || board.selectedSquare == square)
#endif
		.background((rank + file.rawValue - 1).isMultiple(of: 2) ? theme.squareLight : theme.squareDark, in: Rectangle())
		.overlay {
			if board.validSquares.contains(square) {
				Circle()
					.fill(board.lightTurn ? theme.pieceLight : theme.pieceDark)
					.scaleEffect(x: 0.25, y: 0.25)
					.transition(.opacity.animation(.linear))
			}
		}
	}
}
