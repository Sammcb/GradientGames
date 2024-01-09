//
//  ChessSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessSquareView: View {
	@Environment(\.chessTheme) private var theme
	@Environment(ChessGame.self) private var game: ChessGame
	let file: ChessFile
	let rank: Int
	
	private func select(square: ChessSquare) {
		if let piece = game.board.pieces[square], piece.isLight == game.board.lightTurn {
			game.selectedSquare = square
			return
		}
		
		guard let selectedSquare = game.selectedSquare, game.board.canMove(from: selectedSquare, to: square) else {
			return
		}
		
		game.selectedSquare = nil
		game.board.move(from: selectedSquare, to: square)
		
		let rank = game.board.lightTurn ? 8 : 1
		guard let piece = game.board.pieces[square], piece.group == .pawn, square.rank == rank else {
			return
		}
		game.pawnSquare = square
	}
	
	var body: some View {
		let square = ChessSquare(file: file, rank: rank)
		let kingState = game.kingState(isLight: game.board.lightTurn)
#if !os(tvOS)
		let gameOver = kingState == .checkmate || kingState == .stalemate
#endif
		Button {
			select(square: square)
		} label: {
			Text("")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
#if os(tvOS)
		.buttonStyle(NoneButtonStyle())
		.disabled(game.pawnSquare != nil || game.selectedSquare == square)
#else
		.buttonStyle(.borderless)
		.disabled(gameOver || game.pawnSquare != nil || game.selectedSquare == square)
#endif
		.background((rank + file.rawValue - 1).isMultiple(of: 2) ? theme.squareLight : theme.squareDark, in: Rectangle())
	}
}
