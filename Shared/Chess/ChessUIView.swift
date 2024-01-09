//
//  ChessUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessTimesTimelineView: View {
	@Environment(ChessGame.self) private var game: ChessGame
	@AppStorage(Setting.flipUI.rawValue) private var flipped = false
	
	var body: some View {
		TimelineView(.periodic(from: .now, by: 1 / 10)) { timeline in
			ChessTimesView(date: timeline.date)
		}
		.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct ChessTimesView: View {
	@Environment(\.chessTheme) private var theme
	@Environment(ChessGame.self) private var game: ChessGame
	let date: Date
	
	var body: some View {
		VStack {
			Text(ChessState.shared.times.stringFor(lightTime: true))
				.foregroundStyle(theme.pieceLight)
			Text(ChessState.shared.times.stringFor(lightTime: false))
				.foregroundStyle(theme.pieceDark)
		}
		.onAppear {
			ChessState.shared.times.lastUpdate = date
		}
		.onChange(of: date) {
			let lightTurn = game.board.lightTurn
			let kingState = game.kingState(isLight: lightTurn)
			guard kingState == .ok || kingState == .check else {
				return
			}
			
			let interval = ChessState.shared.times.lastUpdate.distance(to: date)
			
			if lightTurn {
				ChessState.shared.times.light += interval
			} else {
				ChessState.shared.times.dark += interval
			}
			ChessState.shared.times.lastUpdate = date
		}
	}
}

struct ChessKingStatusView: View {
	@Environment(\.chessTheme) private var theme
	@Environment(ChessGame.self) private var game: ChessGame
	let isLight: Bool
	
	private func stateSymbol(isLight: Bool) -> String {
		let opponentKingState = game.kingState(isLight: !isLight)
		if opponentKingState == .stalemate {
			return "minus"
		}
		
		switch game.kingState(isLight: isLight) {
		case .ok:
			return "checkmark"
		case .check:
			return "exclamationmark.triangle"
		case .checkmate:
			return "x"
		case .stalemate:
			return "minus"
		}
	}
	
	var body: some View {
		Image(systemName: stateSymbol(isLight: isLight))
			.symbolVariant(.fill.circle)
			.foregroundStyle(isLight ? theme.pieceLight : theme.pieceDark)
			.font(.largeTitle)
	}
}

struct ChessStatusView: View {
	@Environment(ChessGame.self) private var game: ChessGame
	@AppStorage(Setting.flipUI.rawValue) private var flipped = false
	
	var body: some View {
		let lightTurn = game.board.lightTurn
		ChessKingStatusView(isLight: lightTurn)
			.rotationEffect(!lightTurn && flipped ? .radians(.pi) : .zero)
			.animation(.easeIn, value: lightTurn)
	}
}

struct ChessUIView: View {
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = true
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			Spacer()
			
			ChessStatusView()
			
			Spacer()
			
			if enableTimer {
				ChessTimesTimelineView()
				
				Spacer()
			}
		}
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
	}
}
