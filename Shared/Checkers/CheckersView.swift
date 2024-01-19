//
//  CheckersView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI
import SwiftData

struct CheckersThemeKey: EnvironmentKey {
	static let defaultValue = CheckersUITheme()
}

extension EnvironmentValues {
	var checkersTheme: CheckersUITheme {
		get {
			self[CheckersThemeKey.self]
		}
		
		set {
			self[CheckersThemeKey.self] = newValue
		}
	}
}

struct CheckersUITheme {
	let squareLight: Color
	let squareDark: Color
	let pieceLight: Color
	let pieceDark: Color
	
	init(theme: Theme? = nil) {
		squareLight = theme?.colors[.squareLight] ?? Color(red: 196 / 255, green: 180 / 255, blue: 151 / 255)
		squareDark = theme?.colors[.squareDark] ?? Color(red: 168 / 255, green: 128 / 255, blue: 99 / 255)
		pieceLight = theme?.colors[.pieceLight] ?? Color(red: 230 / 255, green: 212 / 255, blue: 162 / 255)
		pieceDark = theme?.colors[.pieceDark] ?? Color(red: 64 / 255, green: 57 / 255, blue: 52 / 255)
	}
}

struct CheckersView: View {
	@Environment(\.checkersTheme) private var theme
	var board: CheckersBoard
	var enableUndo: Bool
	var flipped: Bool
	var enableTimer: Bool
	var showMoves: Bool
	
	var body: some View {
		GeometryReader { geometry in
			let vertical = geometry.size.width < geometry.size.height
			let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
			
			layout {
				CheckersUIView(board: board, enableTimer: enableTimer, flipped: flipped, vertical: vertical)
				
				CheckersBoardView(board: board, showMoves: showMoves)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.background(.linearGradient(colors: [theme.squareDark, theme.squareLight], startPoint: .top, endPoint: .bottom))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.font(.system(.headline, design: .rounded).bold().monospaced())
		}
		.onAppear {
			board.selectedSquare = board.forcedSelectedSquare
			board.times.lastUpdate = Date()
		}
		.onDisappear {
			board.selectedSquare = board.forcedSelectedSquare
		}
#if os(tvOS)
		.onPlayPauseCommand {
			guard enableUndo else {
				return
			}
			
			board.undo()
		}
#else
//		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Checkers")
		.toolbar {
			if enableUndo {
				ToolbarItem {
					Button(action: board.undo) {
						Image(systemName: "arrow.uturn.backward")
							.symbolVariant(.circle.fill)
							.rotationEffect(board.lightTurn && flipped ? .radians(.pi) : .zero)
							.animation(.easeIn, value: board.lightTurn)
					}
					.disabled(!board.undoEnabled)
				}
			}
		}
#endif
	}
}
