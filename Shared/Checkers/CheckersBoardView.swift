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
	var showMoves: Bool
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
							CheckersSquareView(board: board, showMoves: showMoves, column: column, row: row)
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
								let scale = selected ? 1 : 0.75
								GeometryReader { geometry in
									CheckersPieceView(isLight: piece.isLight, kinged: piece.kinged)
										.matchedGeometryEffect(id: piece.id, in: pieceAnimation)
										.frame(width: geometry.size.width * scale, height: geometry.size.height * scale)
										.transition(.opacity.animation(.easeIn))
										.allowsHitTesting(false)
										.id(piece.id)
										.frame(maxWidth: .infinity, maxHeight: .infinity)
								}
							} else {
								Color.clear
							}
						}
					}
				}
			}
			.animation(.easeInOut(duration: 0.6), value: board.history)
			.animation(.easeInOut, value: board.selectedSquare)
		}
		.aspectRatio(1, contentMode: .fit)
	}
}
