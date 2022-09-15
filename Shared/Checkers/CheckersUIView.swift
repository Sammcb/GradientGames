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
		TimelineView(.periodic(from: .now, by: 1 / 60)) { timeline in
			CheckersTimesView(date: timeline.date)
		}
		.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct CheckersTimesView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	@AppStorage(Setting.checkersEnableTimer.rawValue) private var enableTimer = true
	private let cadence: TimeInterval = 1 / 60
	let date: Date
	
	var body: some View {
		VStack {
			Text(CheckersState.shared.times.stringFor(lightTime: true))
				.foregroundColor(theme.pieceLight)
			Text(CheckersState.shared.times.stringFor(lightTime: false))
				.foregroundColor(theme.pieceDark)
		}
		.opacity(enableTimer ? 1 : 0)
		.onChange(of: date) { _ in
			if game.board.gameOver {
				return
			}
			
			if game.board.lightTurn {
				CheckersState.shared.times.light += cadence
			} else {
				CheckersState.shared.times.dark += cadence
			}
			CheckersState.shared.times.lastUpdate = date
		}
	}
}

struct CheckersStateView: View {
	@Environment(\.checkersTheme) private var theme
	@EnvironmentObject private var game: CheckersGame
	@AppStorage(Setting.checkersFlipUI.rawValue) private var flipped = false
	let isLight: Bool
	
	var body: some View {
		Image(systemName: "crown")
			.symbolVariant(isLight ? .none : .fill)
			.opacity(game.board.gameOver && game.board.lightTurn != isLight ? 1 : 0)
			.foregroundColor(isLight ? theme.pieceLight : theme.pieceDark)
			.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
			.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct CheckersStatusView: View {
	@EnvironmentObject private var game: CheckersGame
	
	var body: some View {
		HStack {
			CheckersStateView(isLight: true)
			
			CheckersPieceView(isLight: game.board.lightTurn, kinged: true)
				.frame(width: 50, height: 50)
			
			CheckersStateView(isLight: false)
		}
	}
}

struct CheckersUndoView: View {
	@EnvironmentObject private var game: CheckersGame
	@AppStorage(Setting.checkersEnableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.checkersFlipUI.rawValue) private var flipped = false
	
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
		.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct CheckersUIView: View {
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			Spacer()
			
			CheckersTimesTimelineView()
			
			Spacer()
			
			CheckersStatusView()
			
			Spacer()
			
			CheckersUndoView()
			
			Spacer()
		}
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
	}
}
