//
//  CheckersUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersTimeView: View {
	@Environment(\.checkersTheme) private var theme
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	var board: CheckersBoard
	let isLight: Bool
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	var body: some View {
		Label(board.times.stringFor(lightTime: isLight), systemImage: "stopwatch")
			.symbolVariant(.fill)
			.padding()
			.foregroundStyle(isLight ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
			.rotation3DEffect(board.lightTurn && flipUI ? .radians(.pi) : .zero, axis: (x: 1, y: 0, z: 0))
			.rotation3DEffect(board.lightTurn && flipUI ? .radians(.pi) : .zero, axis: (x: 0, y: 1, z: 0))
			.frame(width: enableTimer ? nil : 0, height: enableTimer ? nil : 0)
			.glassEffect(.clear)
			.animation(.easeIn, value: board.lightTurn)
			.opacity(enableTimer ? 1 : 0)
			.scaleEffect(enableTimer ? 1 : 0)
			.animation(.easeIn, value: enableTimer)
			.onReceive(timer) { currentDate in
				guard board.lightTurn == isLight else {
					return
				}

				if board.gameOver {
					return
				}

				board.incrementTime(at: currentDate, isLight: isLight)
			}
	}
}

struct CheckersStateView: View {
	@Environment(\.checkersTheme) private var theme
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	var board: CheckersBoard

	var body: some View {
		let toggleColor = board.gameOver ? !board.lightTurn : board.lightTurn
		Image(systemName: board.gameOver ? "crown" : "circle.circle")
			.symbolVariant(.fill)
			.padding()
			.foregroundStyle(toggleColor ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
			.font(.largeTitle)
			.rotationEffect(board.lightTurn && flipUI ? .radians(.pi) : .zero)
			.glassEffect(.clear)
			.animation(.easeIn, value: board.lightTurn)
	}
}

struct CheckersUIView: View {
	@Environment(\.verticalUI) private var verticalUI
	var board: CheckersBoard

	var body: some View {
		let layout = verticalUI ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

		layout {
			Spacer()
			CheckersTimeView(board: board, isLight: true)
			Spacer()
			CheckersStateView(board: board)
			Spacer()
			CheckersTimeView(board: board, isLight: false)
			Spacer()
		}
		.padding()
	}
}
