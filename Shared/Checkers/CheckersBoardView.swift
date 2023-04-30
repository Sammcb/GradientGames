//
//  CheckersBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersBoardView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	@FocusState private var focusedSquare: CheckersSquare?
	
	private func selectSquare() {
		guard let move = game.board.history.last, move.skip else {
			return
		}
		
		game.selectedSquare = move.toSquare
	}
	
	var body: some View {
		let borderColor = game.board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(CheckersSizeRange.reversed(), id: \.self) { row in
					GridRow {
						ForEach(CheckersSizeRange, id: \.self) { column in
							let square = CheckersSquare(column: column, row: row)
							CheckersSquareView(column: column, row: row)
								.focused($focusedSquare, equals: square)
								.border(focusedSquare == square ? borderColor : .clear, width: 5)
						}
					}
				}
			}
			
			GeometryReader { geometry in
				let boardLength = geometry.size.width
				ForEach(game.pieces) { piece in
					let pieceIndex = game.board.pieces.firstIndex(of: piece)!
					let pieceColor = piece.isLight ? theme.pieceLight : theme.pieceDark
					let square = CheckersPieces.square(at: pieceIndex)
					CheckersPieceView(isLight: piece.isLight, kinged: piece.kinged)
						.allowsHitTesting(false)
						.scaleEffect(0.5)
						.frame(width: boardLength / 8, height: boardLength / 8)
						.background {
							Circle()
								.stroke(game.selectedSquare == square ? pieceColor : .clear, lineWidth: boardLength / 128)
								.frame(width: boardLength / 10, height: boardLength / 10)
						}
						.offset(x: CGFloat(square.column - 1) * boardLength / 8, y: CGFloat(8 - square.row) * boardLength / 8)
						.transition(.opacity.animation(.linear))
						.animation(.linear, value: game.board)
						.zIndex(1)
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
		.onAppear {
			selectSquare()
		}
		.onChange(of: game.board) { _ in
			selectSquare()
		}
	}
}
