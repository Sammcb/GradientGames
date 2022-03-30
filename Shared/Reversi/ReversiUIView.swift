//
//  ReversiUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiTimesTimelineView: View {
	@EnvironmentObject private var game: ReversiGame
	@AppStorage(Settings.Key.reversiFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		TimelineView(.periodic(from: .now, by: 1 / 60)) { timeline in
			ReversiTimesView(date: timeline.date)
		}
		.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct ReversiTimesView: View {
	@Environment(\.reversiTheme) private var theme
	@EnvironmentObject private var game: ReversiGame
	@AppStorage(Settings.Key.reversiEnableTimer.rawValue) private var enableTimer = true
	private let cadence: TimeInterval = 1 / 60
	let date: Date
	
	var body: some View {
		VStack {
			Text(ReversiState.times.stringFor(lightTime: true))
				.foregroundColor(theme.pieceLight)
			Text(ReversiState.times.stringFor(lightTime: false))
				.foregroundColor(theme.pieceDark)
		}
		.opacity(enableTimer ? 1 : 0)
		.onChange(of: date) { _ in
			if game.board.gameOver {
				return
			}
			
			if game.board.lightTurn {
				ReversiState.times.light += cadence
			} else {
				ReversiState.times.dark += cadence
			}
			ReversiState.times.lastUpdate = date
		}
	}
}

struct ReversiStatusView: View {
	@EnvironmentObject private var game: ReversiGame
	
	var body: some View {
		ReversiPieceView(isLight: game.board.lightTurn)
			.frame(width: 64, height: 64)
	}
}

struct ReversiUndoView: View {
	@EnvironmentObject private var game: ReversiGame
	@AppStorage(Settings.Key.reversiEnableUndo.rawValue) private var enableUndo = true
	@AppStorage(Settings.Key.reversiFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		Button {
			game.board.undo()
		} label: {
			Image(systemName: "arrow.uturn.backward")
				.symbolVariant(.circle.fill)
				.font(.system(size: 50))
		}
		.opacity(enableUndo ? 1 : 0)
		.disabled(game.board.history.isEmpty || !enableUndo)
		.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct ReversiPortraitUIView: View {
	var body: some View {
		HStack {
			ReversiTimesTimelineView()
				.frame(maxWidth: .infinity)
			
			ReversiStatusView()
				.frame(maxWidth: .infinity)
			
			ReversiUndoView()
				.frame(maxWidth: .infinity)
			
		}
		.padding(.bottom)
		.background(.ultraThinMaterial)
	}
}

struct ReversiLandscapeUIView: View {
	var body: some View {
		VStack {
			ReversiUndoView()
				.frame(maxHeight: .infinity)
			
			ReversiStatusView()
				.frame(maxHeight: .infinity)
			
			ReversiTimesTimelineView()
				.frame(maxHeight: .infinity)
		}
		.padding(.horizontal)
		.background(.ultraThinMaterial)
	}
}
