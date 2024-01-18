//
//  CheckersBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersBoardView: View {
	@Environment(\.checkersTheme) private var theme
	var board: CheckersBoard
	@FocusState private var focusedSquare: Checkers.Square?
	@Namespace private var pieceAnimation
	
	var body: some View {
		let borderColor = board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(Checkers.SizeRange.reversed(), id: \.self) { row in
					GridRow {
						ForEach(Checkers.SizeRange, id: \.self) { column in
							let square = Checkers.Square(column: column, row: row)
							CheckersSquareView(board: board, column: column, row: row)
								.focused($focusedSquare, equals: square)
								.border(focusedSquare == square ? borderColor : .clear, width: 5)
						}
					}
				}
			}
			
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(Checkers.SizeRange.reversed(), id: \.self) { row in
					GridRow {
						ForEach(Checkers.SizeRange, id: \.self) { column in
							if let piece = board.pieces[column, row] {
								let selected = board.selectedSquare == Checkers.Square(column: column, row: row)
								CheckersPieceView(isLight: piece.isLight, kinged: piece.kinged)
									.scaleEffect(selected ? 1.4 : 1)
									.animation(.linear, value: board.selectedSquare)
									.matchedGeometryEffect(id: piece.id, in: pieceAnimation)
									.allowsHitTesting(false)
							} else {
								Spacer()
									.frame(maxWidth: .infinity, maxHeight: .infinity)
							}
						}
					}
				}
			}
			.animation(.linear, value: board.history)
			.transition(.opacity.animation(.linear))
		}
		.aspectRatio(1, contentMode: .fit)
	}
}
