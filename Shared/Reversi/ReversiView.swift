//
//  ReversiView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiThemeKey: EnvironmentKey {
	static let defaultValue = ReversiUITheme()
}

extension EnvironmentValues {	
	var reversiTheme: ReversiUITheme {
		get {
			self[ReversiThemeKey.self]
		}
		
		set {
			self[ReversiThemeKey.self] = newValue
		}
	}
}

struct ReversiUITheme {
	let border: Color
	let square: Color
	let pieceLight: Color
	let pieceDark: Color
	
	init(theme: ReversiTheme) {
		square = Color(theme.square)
		border = Color(theme.border)
		pieceLight = Color(theme.pieceLight)
		pieceDark = Color(theme.pieceDark)
	}
	
	init() {
		square = Color(red: 32 / 255, green: 168 / 255, blue: 96 / 255)
		border = Color(red: 68 / 255, green: 220 / 255, blue: 138 / 255)
		pieceLight = .white
		pieceDark = .black
	}
}

struct ReversiView: View {
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var themes: FetchedResults<ReversiTheme>
	@EnvironmentObject private var game: ReversiGame
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.reversiEnableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.reversiFlipUI.rawValue) private var flipped = false
	private var theme: ReversiUITheme {
		guard let selectedTheme = themes.first(where: { $0.id!.uuidString == reversiTheme }) else {
			return ReversiUITheme()
		}
		return ReversiUITheme(theme: selectedTheme)
	}
	
	var body: some View {
		GeometryReader { geometry in
			let vertical = geometry.size.width < geometry.size.height
			let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
			
			layout {
				ReversiUIView(vertical: vertical)
				
				ReversiBoardView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				ReversiStatsView(vertical: vertical)
			}
			.background(.linearGradient(colors: [theme.square, theme.border], startPoint: .top, endPoint: .bottom))
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
			
			game.board.undo()
		}
#else
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Reversi")
		.toolbar {
			if enableUndo {
				ToolbarItem {
					Button {
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
		.environment(\.reversiTheme, theme)
	}
}
