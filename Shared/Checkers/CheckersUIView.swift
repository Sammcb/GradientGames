//
//  CheckersUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersTimesTimelineView: View {
	@EnvironmentObject private var game: CheckersGame
	@AppStorage(Setting.checkersFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		TimelineView(.periodic(from: .now, by: 1 / 10)) { timeline in
			CheckersTimesView(date: timeline.date)
		}
		.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct CheckersTimesView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	let date: Date
	
	var body: some View {
		VStack {
			Text(CheckersState.shared.times.stringFor(lightTime: true))
				.foregroundColor(theme.pieceLight)
			Text(CheckersState.shared.times.stringFor(lightTime: false))
				.foregroundColor(theme.pieceDark)
		}
		.onAppear {
			CheckersState.shared.times.lastUpdate = date
		}
		.onChange(of: date) { _ in
			if game.board.gameOver {
				return
			}
			
			let interval = CheckersState.shared.times.lastUpdate.distance(to: date)
			
			if game.board.lightTurn {
				CheckersState.shared.times.light += interval
			} else {
				CheckersState.shared.times.dark += interval
			}
			CheckersState.shared.times.lastUpdate = date
		}
	}
}

struct CheckersStateView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	@AppStorage(Setting.checkersFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		let lightTurn = game.board.lightTurn
		let toggleColor = game.board.gameOver ? !lightTurn : lightTurn
		Image(systemName: game.board.gameOver ? "crown" : "circle.circle")
			.symbolVariant(.fill)
			.font(.largeTitle)
			.foregroundColor(toggleColor ? theme.pieceLight : theme.pieceDark)
			.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct CheckersUIView: View {
	@AppStorage(Setting.checkersEnableTimer.rawValue) private var enableTimer = true
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			Spacer()
			
			CheckersStateView()
			
			Spacer()
			
			if enableTimer {
				CheckersTimesTimelineView()
				
				Spacer()
			}
		}
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
	}
}
