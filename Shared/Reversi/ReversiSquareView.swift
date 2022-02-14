//
//  ReversiSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiSquareStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background(.clear)
	}
}

struct ReversiSquareView: View {
	@Environment(\.reversiTheme) private var theme
	@Environment(\.reversiBoardLength) private var boardLength
	@EnvironmentObject private var game: ReversiGame
	let column: Int
	let row: Int
	
	var body: some View {
		let square = ReversiSquare(column: column, row: row)
		let animation: Animation = .linear(duration: 0.3)
		ZStack {
			Button {
				guard game.board.canPlace(at: square) else {
					return
				}
				
				game.board.place(at: square)
			} label: {
				Text("")
					.frame(width: boardLength / 8, height: boardLength / 8)
			}
			.disabled(game.board.gameOver)
			.background(theme.square, in: Rectangle())
#if os(tvOS)
			.buttonStyle(ReversiSquareStyle())
#endif
			
			if let piece = game.board.pieces[square] {
				ReversiPieceView(isLight: piece.isLight)
					.frame(width: boardLength / 16, height: boardLength / 16)
					.transition(.opacity.animation(animation))
					.animation(animation, value: game.board)
					.zIndex(1)
			}
		}
	}
}
