//
//  ReversiView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData

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
	
	init(theme: Theme? = nil) {
		square = theme?.colors[.squares] ?? Color(red: 32 / 255, green: 168 / 255, blue: 96 / 255)
		border = theme?.colors[.borders] ?? Color(red: 68 / 255, green: 220 / 255, blue: 138 / 255)
		pieceLight = theme?.colors[.pieceLight] ?? .white
		pieceDark = theme?.colors[.pieceDark] ?? .black
	}
}

struct ReversiView: View {
	@Environment(\.reversiTheme) private var theme
	@State private var themesSheetShown = false
	var board: ReversiBoard
	var enableUndo: Bool
	var flipped: Bool
	var enableTimer: Bool
	var showMoves: Bool
	
	var body: some View {
		GeometryReader { geometry in
			let vertical = geometry.size.width < geometry.size.height
			let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
			
			layout {
				ReversiUIView(board: board, enableTimer: enableTimer, flipped: flipped, vertical: vertical)
				
				ReversiBoardView(board: board, flipped: flipped, showMoves: showMoves)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
#if os(tvOS)
				VStack {
					Button() {
						themesSheetShown.toggle()
					} label: {
						Label("Themes", systemImage: "paintpalette")
							.labelStyle(.iconOnly)
					}
					
					if enableUndo {
						Button(action: board.undo) {
							Label("Undo", systemImage: "arrow.uturn.backward")
								.symbolVariant(.circle.fill)
								.labelStyle(.iconOnly)
						}
						.disabled(!board.undoEnabled)
					}
					
					Spacer()
				}
				.focusSection()
#endif
			}
			.background(.linearGradient(colors: [theme.square, theme.border], startPoint: .top, endPoint: .bottom))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.font(.system(.headline, design: .rounded).bold().monospaced())
		}
		.onAppear {
			board.times.lastUpdate = Date()
		}
		.sheet(isPresented: $themesSheetShown) {
			ThemesView(game: .reversi)
		}
#if os(tvOS)
		.onPlayPauseCommand {
			guard enableUndo else {
				return
			}
			
			board.undo()
		}
#else
#if os(iOS)
		.navigationBarTitleDisplayMode(.inline)
#endif
		.navigationTitle("Reversi")
		.toolbar {
			ToolbarItemGroup {
				if enableUndo {
					Button(action: board.undo) {
						Image(systemName: "arrow.uturn.backward")
							.symbolVariant(.circle.fill)
							.rotationEffect(board.lightTurn && flipped ? .radians(.pi) : .zero)
							.animation(.easeIn, value: board.lightTurn)
					}
					.disabled(!board.undoEnabled)
				}
				
				Button() {
					themesSheetShown.toggle()
				} label: {
					Label("Themes", systemImage: "paintpalette")
				}
			}
		}
#endif
	}
}
