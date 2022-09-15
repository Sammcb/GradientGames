//
//  CheckersSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersSquareStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background(.clear)
	}
}

struct CheckersSquareView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	let column: Int
	let row: Int
	
	private func select(square: CheckersSquare) {
		if game.board.history.last?.skip ?? false, game.board.pieces[square] != nil {
			return
		}
		
		if let piece = game.board.pieces[square], piece.isLight == game.board.lightTurn {
			game.selectedSquare = square
			return
		}
		
		guard let selectedSquare = game.selectedSquare, game.board.canMove(from: selectedSquare, to: square) else {
			return
		}
		
		game.selectedSquare = nil
		game.board.move(from: selectedSquare, to: square)
	}
	
	var body: some View {
		let square = CheckersSquare(column: column, row: row)
		Button {
			select(square: square)
		} label: {
			Text("")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
#if os(tvOS)
		.buttonStyle(CheckersSquareStyle())
#endif
		.background((row + column - 1).isMultiple(of: 2) ? theme.squareLight : theme.squareDark, in: Rectangle())
		.disabled(game.board.gameOver)
	}
}
