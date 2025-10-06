//
//  ChessBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessBoardView: View {
	@Environment(\.chessTheme) private var theme
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	var board: ChessBoard
	@FocusState private var focusedSquare: Chess.Square?
	@Namespace private var pieceAnimation

	var body: some View {
		let borderColor = board.lightTurn ? theme.colors[.pieceLight] : theme.colors[.pieceDark]
		ZStack {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(Chess.Ranks.reversed(), id: \.self) { rank in
					GridRow {
						ForEach(Chess.File.validFiles) { file in
							let square = Chess.Square(file: file, rank: rank)
							ChessSquareView(board: board, file: file, rank: rank)
								.focused($focusedSquare, equals: square)
								.border(focusedSquare == square ? borderColor : .clear, width: 5)
						}
					}
				}
			}

			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(Chess.Ranks.reversed(), id: \.self) { rank in
					GridRow {
						ForEach(Chess.File.validFiles) { file in
							if let piece = board.pieces[file, rank] {
								let selected = board.selectedSquare == Chess.Square(file: file, rank: rank)
								let scale = selected ? 1 : 0.75
								ChessPieceView(group: piece.group, isLight: piece.isLight)
									.scaleEffect(x: scale, y: scale)
									.matchedGeometryEffect(id: piece.id, in: pieceAnimation)
									.transition(.opacity.animation(.easeIn))
									.allowsHitTesting(false)
									.rotationEffect(!piece.isLight && flipUI ? .radians(.pi) : .zero)
									.id(piece.id)
									.frame(maxWidth: .infinity, maxHeight: .infinity)
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
