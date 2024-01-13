//
//  ChessUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessTimesTimelineView: View {
	var board: ChessBoardTest
	var flipped: Bool
	
	var body: some View {
		TimelineView(.periodic(from: .now, by: 1 / 10)) { timeline in
			ChessTimesView(board: board, date: timeline.date)
		}
		.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: board.lightTurn)
	}
}

struct ChessTimesView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoardTest
	@State var date: Date
	
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
			if board.gameOver {
				return
			}
			
			let interval = ChessState.shared.times.lastUpdate.distance(to: date)
			
			if board.lightTurn {
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
	var board: ChessBoardTest
	
	private func stateSymbol(isLight: Bool) -> String {
		let opponentKingState = board.lightTurn ? board.kingStates.dark : board.kingStates.light
		if opponentKingState == .stalemate {
			return "minus"
		}
		
		let kingState = board.lightTurn ? board.kingStates.light : board.kingStates.dark
		switch kingState {
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
		Image(systemName: stateSymbol(isLight: board.lightTurn))
			.symbolVariant(.fill.circle)
			.foregroundStyle(board.lightTurn ? theme.pieceLight : theme.pieceDark)
			.font(.largeTitle)
	}
}

struct ChessUIView: View {
	var board: ChessBoardTest
	var enableTimer: Bool
	var flipped: Bool
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			Spacer()
			
			ChessKingStatusView(board: board)
				.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
				.animation(.easeIn, value: board.lightTurn)
			
			// might be nice to have the timers layed out like: 00:00     00:00
			// right under the title, then have the king status not shown if .ok
			// otherwise, it appears in a rounded box right under with transparent background
			// maybe could even share space with the promotion UI
			// promotion UI as a menu popup from the pawn could be cool too
			
			Spacer()
			
			if enableTimer {
				ChessTimesTimelineView(board: board, flipped: flipped)
				
				Spacer()
			}
		}
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
	}
}
