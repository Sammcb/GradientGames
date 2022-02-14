//
//  ReversiBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiBoardView: View {
	@Environment(\.reversiTheme) private var theme
	@EnvironmentObject private var game: ReversiGame
	@FocusState private var focusedSquare: ReversiSquare?
	
	var body: some View {
		let borderColor = game.board.lightTurn ? theme.pieceLight : theme.pieceDark
		VStack(alignment: .center, spacing: 0) {
			ForEach(ReversiSizeRange.reversed(), id: \.self) { row in
				HStack(spacing: 0) {
					ForEach(ReversiSizeRange, id: \.self) { column in
						let square = ReversiSquare(column: column, row: row)
						ReversiSquareView(column: column, row: row)
							.focused($focusedSquare, equals: square)
							.border(focusedSquare == square ? borderColor : theme.border, width: focusedSquare == square ? 5 : 1)
					}
				}
			}
		}
	}
}
