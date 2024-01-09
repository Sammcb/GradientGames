//
//  ReversiUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiTimesTimelineView: View {
	@Environment(ReversiGame.self) private var game: ReversiGame
	@AppStorage(Setting.flipUI.rawValue) private var flipped = false
	
	var body: some View {
		TimelineView(.periodic(from: .now, by: 1 / 10)) { timeline in
			ReversiTimesView(date: timeline.date)
		}
		.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct ReversiTimesView: View {
	@Environment(\.reversiTheme) private var theme
	@Environment(ReversiGame.self) private var game: ReversiGame
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = true
	let date: Date
	
	var body: some View {
		VStack {
			Text(ReversiState.shared.times.stringFor(lightTime: true))
				.foregroundStyle(theme.pieceLight)
			Text(ReversiState.shared.times.stringFor(lightTime: false))
				.foregroundStyle(theme.pieceDark)
		}
		.onAppear {
			ReversiState.shared.times.lastUpdate = date
		}
		.onChange(of: date) {
			if game.board.gameOver {
				return
			}
			
			let interval = ReversiState.shared.times.lastUpdate.distance(to: date)
			
			if game.board.lightTurn {
				ReversiState.shared.times.light += interval
			} else {
				ReversiState.shared.times.dark += interval
			}
			ReversiState.shared.times.lastUpdate = date
		}
	}
}

struct ReversiStatusView: View {
	@Environment(\.reversiTheme) private var theme
	@Environment(ReversiGame.self) private var game: ReversiGame
	@AppStorage(Setting.flipUI.rawValue) private var flipped = false
	
	var body: some View {
		let lightTurn = game.board.lightTurn
		let lightScore = game.pieces.filter({ $0.isLight }).count
		let darkScore = game.pieces.filter({ !$0.isLight }).count
		let gameOverSymbol = lightScore == darkScore ? "minus.circle" : "crown"
		let gameOverColor = lightScore > darkScore ? theme.pieceLight : theme.pieceDark
		let turnColor = lightTurn ? theme.pieceLight : theme.pieceDark
		let symbolColor = game.board.gameOver ? gameOverColor : turnColor
		Image(systemName: game.board.gameOver ? gameOverSymbol : "circle")
			.symbolVariant(.fill)
			.font(.largeTitle)
			.foregroundStyle(symbolColor)
			.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct ReversiUIView: View {
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = true
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			Spacer()
			
			ReversiStatusView()
			
			Spacer()
			
			if enableTimer {
				ReversiTimesTimelineView()
				
				Spacer()
			}
		}
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
	}
}
