//
//  ReversiUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiTimesTimelineView: View {
	@EnvironmentObject private var game: ReversiGame
	@AppStorage(Setting.reversiFlipUI.rawValue) private var flipped = false
	
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
	@AppStorage(Setting.reversiEnableTimer.rawValue) private var enableTimer = true
	private let cadence: TimeInterval = 1 / 60
	let date: Date
	
	var body: some View {
		VStack {
			Text(ReversiState.shared.times.stringFor(lightTime: true))
				.foregroundColor(theme.pieceLight)
			Text(ReversiState.shared.times.stringFor(lightTime: false))
				.foregroundColor(theme.pieceDark)
		}
		.opacity(enableTimer ? 1 : 0)
		.onChange(of: date) { _ in
			if game.board.gameOver {
				return
			}
			
			if game.board.lightTurn {
				ReversiState.shared.times.light += cadence
			} else {
				ReversiState.shared.times.dark += cadence
			}
			ReversiState.shared.times.lastUpdate = date
		}
	}
}

struct ReversiStatusView: View {
	@EnvironmentObject private var game: ReversiGame
	
	var body: some View {
		ReversiPieceView(isLight: game.board.lightTurn)
			.frame(width: 50, height: 50)
	}
}

struct ReversiUndoView: View {
	@EnvironmentObject private var game: ReversiGame
	@AppStorage(Setting.reversiEnableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.reversiFlipUI.rawValue) private var flipped = false
	
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

struct ReversiUIView: View {
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			Spacer()
			
			ReversiTimesTimelineView()
			
			Spacer()
			
			ReversiStatusView()
			
			Spacer()
			
			ReversiUndoView()
			
			Spacer()
		}
		.padding(vertical ? .vertical : .horizontal)
		.background(.ultraThinMaterial)
	}
}
