//
//  ReversiStatsView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiScoreStatusView: View {
	@Environment(\.reversiTheme) private var theme
	@EnvironmentObject private var game: ReversiGame
	let isLight: Bool
	
	var body: some View {
		let lightScore = game.pieces.filter({ $0.isLight }).count
		let darkScore = game.pieces.filter({ !$0.isLight }).count
		let winner = isLight ? lightScore >= darkScore : darkScore >= lightScore
		let crownColor = isLight ? theme.pieceDark : theme.pieceLight
		VStack(spacing: 0) {
			Image(systemName: "crown")
				.symbolVariant(.fill)
				.imageScale(.medium)
				.foregroundColor(game.board.gameOver && winner ? crownColor : .clear)
				.padding(5)
				.background(Circle().foregroundColor(isLight ? theme.pieceLight : theme.pieceDark))
			
			Text("\(isLight ? lightScore : darkScore)")
				.foregroundColor(isLight ? theme.pieceLight : theme.pieceDark)
		}
	}
}

struct ReversiStatsView: View {
	@Environment(\.reversiTheme) private var theme
	@EnvironmentObject private var game: ReversiGame
	@AppStorage(Setting.reversiFlipUI.rawValue) private var flipped = false
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		let lightMoves = game.board.history.filter({ !$0.skip && $0.piece.isLight }).count
		let darkMoves = game.board.history.filter({ !$0.skip && !$0.piece.isLight }).count
		layout {
			Spacer()
			
			ReversiScoreStatusView(isLight: true)
				.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
			
			Text("\(lightMoves + 2)/\(game.board.maxMoves)")
				.foregroundColor(theme.pieceLight)
				.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
			
			Text("\(darkMoves + 2)/\(game.board.maxMoves)")
				.foregroundColor(theme.pieceDark)
				.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
			
			ReversiScoreStatusView(isLight: false)
				.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			
			Spacer()
		}
		.animation(.easeIn, value: game.board.lightTurn)
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
	}
}
