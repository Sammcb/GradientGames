//
//  ReversiBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiBoardView: View {
	@Environment(\.reversiTheme) private var theme
	var board: ReversiBoard
	var flipped: Bool
	var showMoves: Bool
	@FocusState private var focusedSquare: Reversi.Square?
	
	var body: some View {
		let borderColor = board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(Reversi.SizeRange.reversed(), id: \.self) { row in
					GridRow {
						ForEach(Reversi.SizeRange, id: \.self) { column in
							let square = Reversi.Square(column: column, row: row)
							ReversiSquareView(board: board, showMoves: showMoves, column: column, row: row)
								.focused($focusedSquare, equals: square)
								.border(focusedSquare == square ? borderColor : theme.border, width: focusedSquare == square ? 5 : 1)
						}
					}
				}
			}
			
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(Reversi.SizeRange.reversed(), id: \.self) { row in
					GridRow {
						ForEach(Reversi.SizeRange, id: \.self) { column in
							if let piece = board.pieces[column, row] {
								ReversiPieceView(isLight: piece.isLight)
									.transition(.opacity.animation(.easeIn))
									.allowsHitTesting(false)
									.scaleEffect(0.75)
							} else {
								Color.clear
							}
						}
					}
				}
			}
			.animation(.easeInOut(duration: 0.6), value: board.history)
		}
		.aspectRatio(1, contentMode: .fit)
	}
}
