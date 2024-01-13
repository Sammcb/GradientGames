//
//  ChessBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessBoardView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoardTest
	var flipped: Bool
	@FocusState private var focusedSquare: ChessSquare?
	@State private var selectedSquare: ChessSquare?
	
	@Namespace private var pieceAnimation
	
	var body: some View {
		let borderColor = board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(ChessRanks.reversed(), id: \.self) { rank in
					GridRow {
						ForEach(ChessFile.validFiles) { file in
							let square = ChessSquare(file: file, rank: rank)
							ChessSquareView(board: board, selected: $selectedSquare, file: file, rank: rank)
								.focused($focusedSquare, equals: square)
								.border(focusedSquare == square ? borderColor : .clear, width: 5)
						}
					}
				}
			}
			
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(ChessRanks.reversed(), id: \.self) { rank in
					GridRow {
						ForEach(ChessFile.validFiles) { file in
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
