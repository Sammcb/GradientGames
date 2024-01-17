//
//  ChessBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessBoardView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoard
	var flipped: Bool
	@FocusState private var focusedSquare: Chess.Square?
	@Namespace private var pieceAnimation
	
	var body: some View {
		let borderColor = board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(Chess.Ranks.reversed(), id: \.self) { rank in
					GridRow {
						ForEach(Chess.File.validFiles) { file in
							let square = Chess.Square(file: file, rank: rank)
							ChessSquareView(board: board, file: file, rank: rank)
								.animation(.linear, value: board.selectedSquare)
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
								ChessPieceView(piece: piece)
									.matchedGeometryEffect(id: piece.id, in: pieceAnimation)
									.allowsHitTesting(false)
									.rotationEffect(!piece.isLight && flipped ? .radians(.pi) : .zero)
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
