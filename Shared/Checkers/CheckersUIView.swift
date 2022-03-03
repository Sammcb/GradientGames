//
//  CheckersUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersTimesTimelineView: View {
	var body: some View {
		TimelineView(.periodic(from: .now, by: 1 / 60)) { timeline in
			CheckersTimesView(date: timeline.date)
		}
	}
}

struct CheckersTimesView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	@AppStorage(Settings.Key.checkersEnableTimer.rawValue) private var enableTimer = true
	private let cadence: TimeInterval = 1 / 60
	let date: Date
	
	var body: some View {
		VStack {
			Text(CheckersState.times.stringFor(lightTime: true))
				.foregroundColor(theme.pieceLight)
			Text(CheckersState.times.stringFor(lightTime: false))
				.foregroundColor(theme.pieceDark)
		}
		.opacity(enableTimer ? 1 : 0)
		.onChange(of: date) { _ in
			if game.board.gameOver {
				return
			}
			
			if game.board.lightTurn {
				CheckersState.times.light += cadence
			} else {
				CheckersState.times.dark += cadence
			}
			CheckersState.times.lastUpdate = date
		}
	}
}

struct CheckersStateView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	let isLight: Bool
	
	var body: some View {
		Image(systemName: "crown")
			.symbolVariant(isLight ? .none : .fill)
			.opacity(game.board.gameOver && game.board.lightTurn != isLight ? 1 : 0)
			.foregroundColor(isLight ? theme.pieceLight : theme.pieceDark)
	}
}

struct CheckersStatusView: View {
	@EnvironmentObject private var game: CheckersGame
	
	var body: some View {
		HStack {
			CheckersStateView(isLight: true)
			
			CheckersPieceView(isLight: game.board.lightTurn, kinged: true)
				.frame(width: 64, height: 64)
			
			CheckersStateView(isLight: false)
		}
	}
}

struct CheckersUndoView: View {
	@EnvironmentObject private var game: CheckersGame
	@AppStorage(Settings.Key.checkersEnableUndo.rawValue) private var enableUndo = true
	
	var body: some View {
		Button {
			game.selectedSquare = nil
			game.board.undo()
		} label: {
			Image(systemName: "arrow.uturn.backward")
				.symbolVariant(.circle.fill)
				.font(.system(size: 50))
		}
		.opacity(enableUndo ? 1 : 0)
		.disabled(game.board.history.isEmpty || !enableUndo)
	}
}

struct CheckersPortraitUIView: View {
	var body: some View {
		HStack {
			CheckersTimesTimelineView()
				.frame(maxWidth: .infinity)
			
			CheckersStatusView()
				.frame(maxWidth: .infinity)
			
			CheckersUndoView()
				.frame(maxWidth: .infinity)
			
		}
		.padding(.bottom)
		.background(.ultraThinMaterial)
	}
}

struct CheckersLandscapeUIView: View {
	var body: some View {
		VStack {
			CheckersUndoView()
				.frame(maxHeight: .infinity)
			
			CheckersStatusView()
				.frame(maxHeight: .infinity)
			
			CheckersTimesTimelineView()
				.frame(maxHeight: .infinity)
		}
		.padding(.horizontal)
		.background(.ultraThinMaterial)
	}
}

