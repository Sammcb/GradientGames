//
//  ChessUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessTimesTimelineView: View {
	@EnvironmentObject private var game: ChessGame
	@AppStorage(Settings.Key.chessFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		TimelineView(.periodic(from: .now, by: 1 / 60)) { timeline in
			ChessTimesView(date: timeline.date)
		}
		.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct ChessTimesView: View {
	@Environment(\.chessTheme) private var theme
	@EnvironmentObject private var game: ChessGame
	@AppStorage(Settings.Key.chessEnableTimer.rawValue) private var enableTimer = true
	private let cadence: TimeInterval = 1 / 60
	let date: Date
	
	var body: some View {
		VStack {
			Text(ChessState.times.stringFor(lightTime: true))
				.foregroundColor(theme.pieceLight)
			Text(ChessState.times.stringFor(lightTime: false))
				.foregroundColor(theme.pieceDark)
		}
		.opacity(enableTimer ? 1 : 0)
		.onChange(of: date) { _ in
			let lightTurn = game.board.lightTurn
			let kingState = game.kingState(isLight: lightTurn)
			guard kingState == .ok || kingState == .check else {
				return
			}
			
			if lightTurn {
				ChessState.times.light += cadence
			} else {
				ChessState.times.dark += cadence
			}
			ChessState.times.lastUpdate = date
		}
	}
}

struct ChessKingStatusView: View {
	@Environment(\.chessTheme) private var theme
	@EnvironmentObject private var game: ChessGame
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
			.symbolVariant(isLight ? .circle : .fill.circle)
			.foregroundColor(isLight ? theme.pieceLight : theme.pieceDark)
	}
}

struct ChessStatusView: View {
	@EnvironmentObject private var game: ChessGame
	@AppStorage(Settings.Key.chessFlipUI.rawValue) private var flipped = false
	
	var body: some View {
		let lightTurn = game.board.lightTurn
		HStack {
			ChessKingStatusView(isLight: true)
			
			ChessPieceView(group: .rook, isLight: lightTurn)
				.font(.system(size: 60))
			
			ChessKingStatusView(isLight: false)
		}
		.rotationEffect(!lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: lightTurn)
	}
}

struct ChessUndoView: View {
	@EnvironmentObject private var game: ChessGame
	@AppStorage(Settings.Key.chessEnableUndo.rawValue) private var enableUndo = true
	@AppStorage(Settings.Key.chessFlipUI.rawValue) private var flipped = false
	
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
		.disabled(game.pawnSquare != nil || game.board.history.isEmpty || !enableUndo)
		.rotationEffect(!game.board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: game.board.lightTurn)
	}
}

struct ChessPortraitUIView: View {
	var body: some View {
		HStack {
			ChessTimesTimelineView()
				.frame(maxWidth: .infinity)
			
			ChessStatusView()
				.frame(maxWidth: .infinity)
			
			ChessUndoView()
				.frame(maxWidth: .infinity)
			
		}
		.padding(.bottom)
		.background(.ultraThinMaterial)
	}
}

struct ChessLandscapeUIView: View {
	var body: some View {
		VStack {
			ChessUndoView()
				.frame(maxHeight: .infinity)
			
			ChessStatusView()
				.frame(maxHeight: .infinity)
			
			ChessTimesTimelineView()
				.frame(maxHeight: .infinity)
		}
		.padding(.horizontal)
		.background(.ultraThinMaterial)
	}
}
