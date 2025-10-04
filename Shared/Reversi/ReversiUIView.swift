//
//  ReversiUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiTimeView: View {
	@Environment(\.reversiTheme) private var theme
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	var board: ReversiBoard
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

struct ReversiStatusView: View {
	@Environment(\.reversiTheme) private var theme
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	var board: ReversiBoard
	
	var body: some View {
		let pieces = board.pieces.compactMap({ piece in piece })
		let lightScore = pieces.filter({ piece in piece.isLight }).count
		let darkScore = pieces.filter({ piece in !piece.isLight }).count
		let gameOverSymbol = lightScore == darkScore ? "minus.circle" : "crown"
		let gameOverColor = lightScore > darkScore ? theme.colors[.pieceLight] : theme.colors[.pieceDark]
		let turnColor = board.lightTurn ? theme.colors[.pieceLight] : theme.colors[.pieceDark]
		let symbolColor = board.gameOver ? gameOverColor : turnColor
		Image(systemName: board.gameOver ? gameOverSymbol : "circle")
			.symbolVariant(.fill)
			.padding()
			.foregroundStyle(symbolColor)
			.font(.largeTitle)
			.rotationEffect(board.lightTurn && flipUI ? .radians(.pi) : .zero)
			.glassEffect(.clear)
			.animation(.easeIn, value: board.lightTurn)
			.animation(.easeIn, value: board.history)
	}
}

struct ReversiScoreStatusView: View {
	@Environment(\.reversiTheme) private var theme
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	var board: ReversiBoard
	var isLight: Bool
	
	var body: some View {
		let pieces = board.pieces.compactMap({ piece in piece })
		let lightScore = pieces.filter({ piece in piece.isLight }).count
		let darkScore = pieces.filter({ piece in !piece.isLight }).count
		Label("x\(isLight ? lightScore : darkScore)".padding(toLength: 3, withPad: " ", startingAt: 0), systemImage: "circle")
			.symbolVariant(.fill)
			.padding()
			.foregroundStyle(isLight ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
			.rotation3DEffect(board.lightTurn && flipUI ? .radians(.pi) : .zero, axis: (x: 1, y: 0, z: 0))
			.rotation3DEffect(board.lightTurn && flipUI ? .radians(.pi) : .zero, axis: (x: 0, y: 1, z: 0))
			.glassEffect(.clear)
			.animation(.easeIn, value: board.lightTurn)
	}
}

struct ReversiUIView: View {
	@Environment(\.verticalUI) private var verticalUI
	var board: ReversiBoard
	
	var body: some View {
		let layout = verticalUI ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			Spacer()
			VStack {
				ReversiScoreStatusView(board: board, isLight: false)
				ReversiTimeView(board: board, isLight: false)
			}
			Spacer()
			ReversiStatusView(board: board)
			Spacer()
			VStack {
				ReversiScoreStatusView(board: board, isLight: true)
				ReversiTimeView(board: board, isLight: true)
			}
			Spacer()
		}
		.padding()
	}
}
