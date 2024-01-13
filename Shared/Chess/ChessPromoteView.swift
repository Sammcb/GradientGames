//
//  ChessPromoteView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessPromoteView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoardTest
//	@Environment(ChessGame.self) private var game: ChessGame
	var flipped: Bool
//	let isLight: Bool
	let vertical: Bool
	private let groups: [ChessPiece.Group] = [.knight, .bishop, .rook, .queen]
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		layout {
			Spacer()
			ForEach(groups) { group in
				Button {
					board.promote(to: group)
				} label: {
					ChessPieceView(group: group, isLight: board.lightTurn)
						.font(.system(size: 60))
				}
				.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
				
				Spacer()
			}
//			Spacer()
//			
//			Button {
//				board.promote(to: .knight)
//			} label: {
//				ChessPieceView(group: .knight, isLight: board.lightTurn)
//					.font(.system(size: 60))
//			}
//			.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
//			
//			Spacer()
//			
//			Button {
//				board.promote(to: .bishop)
//			} label: {
//				ChessPieceView(group: .bishop, isLight: board.lightTurn)
//					.font(.system(size: 60))
//			}
//			.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
//			
//			Spacer()
//			
//			Button {
//				board.promote(to: .rook)
//			} label: {
//				ChessPieceView(group: .rook, isLight: board.lightTurn)
//					.font(.system(size: 60))
//			}
//			.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
//			
//			Spacer()
//			
//			Button {
//				board.promote(to: .queen)
//			} label: {
//				ChessPieceView(group: .queen, isLight: board.lightTurn)
//					.font(.system(size: 60))
//			}
//			.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
//			
//			Spacer()
		}
		.disabled(!board.promoting)
		.animation(.easeIn, value: board.lightTurn)
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
#if os(tvOS)
		.focusSection()
#endif
		.transition(.opacity.animation(.linear))
	}
}
