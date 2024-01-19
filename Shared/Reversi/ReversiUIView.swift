//
//  ReversiUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiTimeView: View {
	@Environment(\.reversiTheme) private var theme
	var board: ReversiBoard
	var flipped: Bool
	let isLight: Bool
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	var body: some View {
		Text(board.times.stringFor(lightTime: isLight))
			.foregroundStyle(isLight ? theme.pieceLight : theme.pieceDark)
			.rotationEffect(board.lightTurn && flipped ? .radians(.pi) : .zero)
			.animation(.easeIn, value: board.lightTurn)
			.onReceive(timer) { currentDate in
				guard board.lightTurn == isLight else {
					return
				}
				
				if board.gameOver {
					return
				}
				
				let interval = board.times.lastUpdate.distance(to: currentDate)
				
				guard interval > 0 else {
					return
				}
				
				if isLight {
					board.times.light += interval
				} else {
					board.times.dark += interval
				}
				
				board.times.lastUpdate = currentDate
			}
	}
}

struct ReversiStatusView: View {
	@Environment(\.reversiTheme) private var theme
	var board: ReversiBoard
	var flipped: Bool
	
	var body: some View {
		let pieces = board.pieces.compactMap({ piece in piece })
		let lightScore = pieces.filter({ piece in piece.isLight }).count
		let darkScore = pieces.filter({ piece in !piece.isLight }).count
		let gameOverSymbol = lightScore == darkScore ? "minus.circle" : "crown"
		let gameOverColor = lightScore > darkScore ? theme.pieceLight : theme.pieceDark
		let turnColor = board.lightTurn ? theme.pieceLight : theme.pieceDark
		let symbolColor = board.gameOver ? gameOverColor : turnColor
		Image(systemName: board.gameOver ? gameOverSymbol : "circle")
			.padding()
			.symbolVariant(.fill)
			.foregroundStyle(symbolColor)
			.font(.largeTitle)
			.rotationEffect(board.lightTurn && flipped ? .radians(.pi) : .zero)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.animation(.easeIn, value: board.lightTurn)
			.animation(.easeIn, value: board.history)
	}
}

struct ReversiScoreStatusView: View {
	@Environment(\.reversiTheme) private var theme
	var board: ReversiBoard
	var flipped: Bool
	var isLight: Bool
	
	var body: some View {
		let pieces = board.pieces.compactMap({ piece in piece })
		let lightScore = pieces.filter({ piece in piece.isLight }).count
		let darkScore = pieces.filter({ piece in !piece.isLight }).count
		let initialMoves = 2
		let moves = board.history.filter({ move in !move.skip }).filter({ move in move.light == isLight }).count
		VStack(spacing: 0) {
			ZStack {
				ReversiPieceView(isLight: isLight)
					.frame(width: 40, height: 40)
				Text("\(isLight ? lightScore : darkScore)")
					.blendMode(.destinationOut)
			}
			.compositingGroup()
			
			Text("\(moves + initialMoves)/\(board.maxMoves)")
				.foregroundStyle(isLight ? theme.pieceLight : theme.pieceDark)
		}
		.rotationEffect(board.lightTurn && flipped ? .radians(.pi) : .zero)
		.animation(.easeIn, value: board.lightTurn)
	}
}

struct ReversiUIView: View {
	@Environment(\.reversiTheme) private var theme
	var board: ReversiBoard
	var enableTimer: Bool
	var flipped: Bool
	var vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
		let statsLayout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			statsLayout {
				Spacer()
				ReversiScoreStatusView(board: board, flipped: flipped, isLight: false)
				Spacer()
				if enableTimer {
					ReversiTimeView(board: board, flipped: flipped, isLight: false)
					Spacer()
					ReversiTimeView(board: board, flipped: flipped, isLight: true)
					Spacer()
				}
				ReversiScoreStatusView(board: board, flipped: flipped, isLight: true)
				Spacer()
			}
			.padding()
			.background(.ultraThinMaterial)
			
			ReversiStatusView(board: board, flipped: flipped)
				.padding()
		}
		.ignoresSafeArea(edges: vertical ? .horizontal : .vertical)
	}
}
