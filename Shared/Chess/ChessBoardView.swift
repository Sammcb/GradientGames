//
//  ChessBoardView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessBoardView: View {
	@Environment(\.chessTheme) private var theme
	@Environment(\.chessBoardLength) private var boardLength
	@EnvironmentObject private var game: ChessGame
	@FocusState private var focusedSquare: ChessSquare?
	@AppStorage(Settings.Key.chessFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		let animation: Animation = .linear(duration: 0.3)
		let borderColor = game.board.lightTurn ? theme.pieceLight : theme.pieceDark
		ZStack {
			VStack(alignment: .center, spacing: 0) {
				ForEach(ChessRanks.reversed(), id: \.self) { rank in
					HStack(spacing: 0) {
						ForEach(ChessFile.validFiles) { file in
							let square = ChessSquare(file: file, rank: rank)
							ChessSquareView(file: file, rank: rank)
								.focused($focusedSquare, equals: square)
								.border(focusedSquare == square ? borderColor : .clear, width: 5)
						}
					}
				}
			}
			
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
					.offset(x: CGFloat(square.file.rawValue) * boardLength / 8 - boardLength * 9 / 16, y: CGFloat(1 - square.rank) * boardLength / 8 + boardLength * 7 / 16)
					.transition(.opacity.animation(animation))
					.animation(animation, value: game.board)
					.zIndex(1)
			}
		}
	}
}
