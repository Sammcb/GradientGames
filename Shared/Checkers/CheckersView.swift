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
	
	init(theme: Theme) {
//		squareLight = Color(theme.squareLight)
//		squareDark = Color(theme.squareDark)
//		pieceLight = Color(theme.pieceLight)
//		pieceDark = Color(theme.pieceDark)
		squareLight = theme.colors[.squareLight]
		squareDark = theme.colors[.squareDark]
		pieceLight = theme.colors[.pieceLight]
		pieceDark = theme.colors[.pieceDark]
	}
	
	init() {
		squareLight = Color(red: 196 / 255, green: 180 / 255, blue: 151 / 255)
		squareDark = Color(red: 168 / 255, green: 128 / 255, blue: 99 / 255)
		pieceLight = Color(red: 230 / 255, green: 212 / 255, blue: 162 / 255)
		pieceDark = Color(red: 64 / 255, green: 57 / 255, blue: 52 / 255)
	}
}

struct CheckersView: View {
	@Query(sort: \Theme.index) private var themes: [Theme]
	@Environment(CheckersGame.self) private var game: CheckersGame
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.flipUI.rawValue) private var flipped = false
	private var theme: CheckersUITheme {
		guard let selectedTheme = themes.first(where: { $0.id.uuidString == checkersTheme }) else {
			return CheckersUITheme()
		}
		return CheckersUITheme(theme: selectedTheme)
	}
	
	var body: some View {
		GeometryReader { geometry in
			let vertical = geometry.size.width < geometry.size.height
			let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
			
			layout {
				CheckersUIView(vertical: vertical)
				
				CheckersBoardView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.background(.linearGradient(colors: [theme.squareLight, theme.squareDark], startPoint: .top, endPoint: .bottom))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		}
#if os(tvOS)
		.onPlayPauseCommand {
			guard enableUndo else {
				return
			}
			
			if game.board.history.isEmpty {
				return
			}
			
			game.selectedSquare = nil
			game.board.undo()
		}
#else
//		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Checkers")
		.toolbar {
			if enableUndo {
				ToolbarItem {
					Button {
						game.selectedSquare = nil
						game.board.undo()
					} label: {
						Label("Undo", systemImage: "arrow.uturn.backward")
							.symbolVariant(.circle.fill)
							.rotationEffect(game.board.lightTurn && flipped ? .radians(.pi) : .zero)
							.animation(.easeIn, value: game.board.lightTurn)
					}
					.disabled(game.board.history.isEmpty)
				}
			}
		}
#endif
		.environment(\.checkersTheme, theme)
	}
}
