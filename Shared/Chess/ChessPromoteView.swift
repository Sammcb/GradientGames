//
//  ChessPromoteView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessPromoteView: View {
	@Environment(\.chessTheme) private var theme
	@EnvironmentObject private var game: ChessGame
	@AppStorage(Setting.chessFlipUI.rawValue) private var flipped = false
	let isLight: Bool
	let vertical: Bool
	
	private func promote(to group: ChessPiece.Group) {
		let square = game.pawnSquare!
		let piece = ChessPiece(isLight: game.board.lightTurn, group: group)
		game.board.promote(at: square, to: piece)
		game.pawnSquare = nil
	}
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		layout {
			Spacer()
			
			Button {
				promote(to: .knight)
			} label: {
				ChessPieceView(group: .knight, isLight: isLight)
					.font(.system(size: 60))
			}
			.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
			
			Button {
				promote(to: .bishop)
			} label: {
				ChessPieceView(group: .bishop, isLight: isLight)
					.font(.system(size: 60))
			}
			.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
			
			Button {
				promote(to: .rook)
			} label: {
				ChessPieceView(group: .rook, isLight: isLight)
					.font(.system(size: 60))
			}
			.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
			
			Button {
				promote(to: .queen)
			} label: {
				ChessPieceView(group: .queen, isLight: isLight)
					.font(.system(size: 60))
			}
			.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
		}
		.disabled(game.pawnSquare == nil)
		.animation(.easeIn, value: game.board.lightTurn)
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
#if os(tvOS)
		.focusSection()
#endif
		.transition(.opacity.animation(.linear))
	}
}
