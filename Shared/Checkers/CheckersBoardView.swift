//
//  CheckersBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersBoardView: View {
	@Environment(\.checkersTheme) private var theme
	@Environment(\.checkersBoardLength) private var boardLength
	@EnvironmentObject private var game: CheckersGame
	@FocusState private var focusedSquare: CheckersSquare?
	
	private func selectSquare() {
		guard let move = game.board.history.last, move.skip else {
			return
		}
		
		game.selectedSquare = move.toSquare
	}
	
	var body: some View {
		let animation: Animation = .linear(duration: 0.3)
		let borderColor = game.board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			VStack(alignment: .center, spacing: 0) {
				ForEach(CheckersSizeRange.reversed(), id: \.self) { row in
					HStack(spacing: 0) {
						ForEach(CheckersSizeRange, id: \.self) { column in
							let square = CheckersSquare(column: column, row: row)
							CheckersSquareView(column: column, row: row)
								.focused($focusedSquare, equals: square)
								.border(focusedSquare == square ? borderColor : .clear, width: 5)
						}
					}
				}
			}
			
			ForEach(game.pieces) { piece in
				let pieceIndex = game.board.pieces.firstIndex(of: piece)!
				let pieceColor = piece.isLight ? theme.pieceLight : theme.pieceDark
				let square = CheckersPieces.square(at: pieceIndex)
				CheckersPieceView(isLight: piece.isLight, kinged: piece.kinged)
					.allowsHitTesting(false)
					.font(.system(size: boardLength / 12))
					.frame(width: boardLength / 16, height: boardLength / 16)
					.background {
						Circle()
							.stroke(game.selectedSquare == square ? pieceColor : .clear, lineWidth: boardLength / 128)
							.frame(width: boardLength / 10, height: boardLength / 10)
					}
					.offset(x: CGFloat(square.column) * boardLength / 8 - boardLength * 9 / 16, y: CGFloat(1 - square.row) * boardLength / 8 + boardLength * 7 / 16)
					.transition(.opacity.animation(animation))
					.animation(animation, value: game.board)
					.zIndex(1)
			}
		}
		.onAppear {
			selectSquare()
		}
		.onChange(of: game.board) { _ in
			selectSquare()
		}
	}
}
