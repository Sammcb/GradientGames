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
	@FocusState private var focusedSquare: Reversi.Square?
	
	var body: some View {
		let borderColor = board.lightTurn ? theme.pieceLight : theme.pieceDark
		Grid(horizontalSpacing: 0, verticalSpacing: 0) {
			ForEach(Reversi.SizeRange.reversed(), id: \.self) { row in
				GridRow {
					ForEach(Reversi.SizeRange, id: \.self) { column in
						let square = Reversi.Square(column: column, row: row)
						ReversiSquareView(board: board, column: column, row: row)
							.focused($focusedSquare, equals: square)
							.border(focusedSquare == square ? borderColor : theme.border, width: focusedSquare == square ? 5 : 1)
					}
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
	}
}
