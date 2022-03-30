//
//  ChessPromoteView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessPromoteView: View {
	@Environment(\.chessTheme) private var theme
	@Environment(\.chessBoardLength) private var boardLength
	@EnvironmentObject private var game: ChessGame
	@AppStorage(Settings.Key.chessFlipUI.rawValue) private var flipped = false
	let promoteGroups: [ChessPiece.Group] = [.knight, .bishop, .rook, .queen]
	let isLight: Bool
	
	private func promote(to group: ChessPiece.Group) {
		let square = game.pawnSquare!
		let piece = ChessPiece(isLight: game.board.lightTurn, group: group)
		game.board.promote(at: square, to: piece)
		game.pawnSquare = nil
	}
	
	var body: some View {
		Spacer()
		
		ForEach(promoteGroups) { group in
			Button {
				promote(to: group)
			} label: {
				ChessPieceView(group: group, isLight: isLight)
					.frame(width: boardLength / 8, height: boardLength / 8)
			}
			
			Spacer()
		}
		.font(.system(size: 50))
		.disabled(game.pawnSquare == nil)
		.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}
