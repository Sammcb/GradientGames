//
//  ChessSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessSquareView: View {
	@Environment(\.chessTheme) private var theme
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
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
			Color(lightSquare ? theme.colors[.squareLight] : theme.colors[.squareDark])
				.animation(.easeInOut(duration: 0.6), value: board.history)
				.animation(.easeInOut, value: board.selectedSquare)
		}
		.accessibilityIdentifier("File\(file)Rank\(rank)ChessBoardSquareButton")
		.buttonStyle(.borderless)
		.disabled(board.promoting)
		.overlay {
			if showMoves && board.validSquares.contains(square) {
				Circle()
					.fill(board.lightTurn ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
					.scaleEffect(0.25)
					.transition(.scale.animation(.easeOut))
					.allowsHitTesting(false)
			}
		}
	}
}
