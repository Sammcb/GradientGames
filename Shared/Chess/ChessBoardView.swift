//
//  ChessBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessBoardView: View {
	@Environment(\.chessTheme) private var theme
	@EnvironmentObject private var game: ChessGame
	@FocusState private var focusedSquare: ChessSquare?
	@AppStorage(Setting.chessFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		let borderColor = game.board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				ForEach(ChessRanks.reversed(), id: \.self) { rank in
					GridRow {
						ForEach(ChessFile.validFiles) { file in
							let square = ChessSquare(file: file, rank: rank)
							ChessSquareView(file: file, rank: rank)
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
					let square = ChessPieces.square(at: pieceIndex)
					ChessPieceView(piece: piece)
						.allowsHitTesting(false)
						.font(.system(size: boardLength / 12))
						.frame(width: boardLength / 8, height: boardLength / 8)
						.background {
							Circle()
								.stroke(game.selectedSquare == square ? pieceColor : .clear, lineWidth: boardLength / 128)
								.frame(width: boardLength / 10, height: boardLength / 10)
						}
						.rotationEffect(!piece.isLight && flipped ? .radians(.pi) : .zero)
						.offset(x: CGFloat(square.file.rawValue - 1) * boardLength / 8, y: CGFloat(8 - square.rank) * boardLength / 8)
						.transition(.opacity.animation(.linear))
						.animation(.linear, value: game.board)
						.zIndex(1)
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
	}
}
