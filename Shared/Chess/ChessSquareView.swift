//
//  ChessSquareView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessSquareView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoardTest
	@Binding var selected: ChessSquare?
	let file: ChessFile
	let rank: Int
	
	private func select(square: ChessSquare) {
		if let piece = board.pieces[square], piece.isLight == board.lightTurn {
			selected = square
			return
		}
		
		guard let selectedSquare = selected, board.canMove(from: selectedSquare, to: square) else {
			return
		}
		
		selected = nil
		board.move(from: selectedSquare, to: square)
	}
	
	var body: some View {
		let square = ChessSquare(file: file, rank: rank)
		Button {
			select(square: square)
		} label: {
			GeometryReader { geometry in
				Circle()
					.stroke(board.lightTurn ? theme.pieceLight : theme.pieceDark, lineWidth: geometry.size.width / 10)
					.opacity(selected == square ? 1 : 0)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.scaledToFit()
					.scaleEffect(x: 0.8, y: 0.8)
			}
		}
#if os(tvOS)
		.buttonStyle(NoneButtonStyle())
		.disabled(board.promoting || selected == square)
#else
		.buttonStyle(.borderless)
		.disabled(board.gameOver || board.promoting || selected == square)
#endif
		.background((rank + file.rawValue - 1).isMultiple(of: 2) ? theme.squareLight : theme.squareDark, in: Rectangle())
	}
}
