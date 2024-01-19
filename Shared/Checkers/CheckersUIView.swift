//
//  CheckersUIView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersTimeView: View {
	@Environment(\.checkersTheme) private var theme
	var board: CheckersBoard
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

struct CheckersStateView: View {
	@Environment(\.checkersTheme) private var theme
	var board: CheckersBoard
	var flipped: Bool
	
	var body: some View {
		let toggleColor = board.gameOver ? !board.lightTurn : board.lightTurn
		Image(systemName: board.gameOver ? "crown" : "circle.circle")
			.padding()
			.symbolVariant(.fill)
			.foregroundStyle(toggleColor ? theme.pieceLight : theme.pieceDark)
			.font(.largeTitle)
			.rotationEffect(board.lightTurn && flipped ? .radians(.pi) : .zero)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.animation(.easeIn, value: board.lightTurn)
	}
}

struct CheckersUIView: View {
	var board: CheckersBoard
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
					CheckersTimeView(board: board, flipped: flipped, isLight: true)
					Spacer()
					CheckersTimeView(board: board, flipped: flipped, isLight: false)
					Spacer()
				}
				.padding()
				.background(.ultraThinMaterial)
			}
			
			CheckersStateView(board: board, flipped: flipped)
				.padding()
		}
		.ignoresSafeArea(edges: vertical ? .horizontal : .vertical)
	}
}
