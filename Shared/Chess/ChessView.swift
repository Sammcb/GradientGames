//
//  ChessView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData

struct ChessThemeKey: EnvironmentKey {
	static let defaultValue = ChessUITheme()
}

extension EnvironmentValues {	
	var chessTheme: ChessUITheme {
		get {
			self[ChessThemeKey.self]
		}
		
		set {
			self[ChessThemeKey.self] = newValue
		}
	}
}

struct ChessUITheme {
	let squareLight: Color
	let squareDark: Color
	let pieceLight: Color
	let pieceDark: Color
	
	init(theme: Theme? = nil) {
		squareLight = theme?.colors[.squareLight] ?? Color(red: 192 / 255, green: 192 / 255, blue: 192 / 255)
		squareDark = theme?.colors[.squareDark] ?? Color(red: 96 / 255, green: 96 / 255, blue: 96 / 255)
		pieceLight = theme?.colors[.pieceLight] ?? .white
		pieceDark = theme?.colors[.pieceDark] ?? .black
	}
}

extension View {
		func printOutput(_ value: Any) -> Self {
				print(value)
				return self
		}
}

struct ChessView: View {
	@Environment(\.chessTheme) private var theme
	var board: ChessBoardTest
	var enableUndo: Bool
	var flipped: Bool
	var enableTimer: Bool
	
	var body: some View {
		GeometryReader { geometry in
			let vertical = geometry.size.width < geometry.size.height
			let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
			
			layout {
				ChessUIView(board: board, enableTimer: enableTimer, flipped: flipped, vertical: vertical)
					.animation(.linear, value: board.promoting)
				
				ChessBoardView(board: board, flipped: flipped)
					.animation(.linear, value: board.promoting)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				if board.promoting {
					ChessPromoteView(board: board, flipped: flipped, vertical: vertical)
				}
			}
			.background(.linearGradient(colors: [theme.squareLight, theme.squareDark], startPoint: .top, endPoint: .bottom))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.font(.system(.headline, design: .rounded).bold().monospaced())
		}
#if os(tvOS)
		.onPlayPauseCommand {
			guard enableUndo else {
				return
			}
			board.undo()
		}
#else
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Chess")
		.toolbar {
			if enableUndo {
				ToolbarItem {
					Button(action: board.undo) {
						Label("Undo", systemImage: "arrow.uturn.backward")
							.symbolVariant(.circle.fill)
							.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
							.animation(.easeIn, value: board.lightTurn)
					}
					.disabled(!board.undoEnabled)
				}
			}
		}
#endif
	}
}
