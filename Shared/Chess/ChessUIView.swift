//
//  ChessUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessTimeView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoard
	var flipped: Bool
	let isLight: Bool
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	var body: some View {
		Text(board.times.stringFor(lightTime: isLight))
			.foregroundStyle(isLight ? theme.pieceLight : theme.pieceDark)
			.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
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

struct ChessKingStatusView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoard
	var flipped: Bool
	
	var body: some View {
		let kingState = board.lightTurn ? board.kingStates.light : board.kingStates.dark
		let kingStateSymbol = switch kingState {
		case .ok: "checkmark"
		case .check: "exclamationmark.triangle"
		case .checkmate: "x"
		case .stalemate: "minus"
		}
		Image(systemName: kingStateSymbol)
			.padding()
			.symbolVariant(.fill.circle)
			.foregroundStyle(board.lightTurn ? theme.pieceLight : theme.pieceDark)
			.font(.largeTitle)
			.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.animation(.easeIn, value: board.lightTurn)
	}
}

struct ChessUIView: View {
	var board: ChessBoard
	var enableTimer: Bool
	var flipped: Bool
	let vertical: Bool
	
	var body: some View {
		let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
		let timersLayout = vertical ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
		
		layout {
			if enableTimer {
				timersLayout {
					Spacer()
					ChessTimeView(board: board, flipped: flipped, isLight: true)
					Spacer()
					ChessTimeView(board: board, flipped: flipped, isLight: false)
					Spacer()
				}
				.padding()
				.background(.ultraThinMaterial)
			}
			
			ChessKingStatusView(board: board, flipped: flipped)
				.padding()
		}
		.ignoresSafeArea(edges: vertical ? .horizontal : .vertical)
	}
}
