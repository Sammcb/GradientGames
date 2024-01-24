//
//  CheckersView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI
import SwiftData

struct CheckersThemeKey: EnvironmentKey {
	static let defaultValue = Theme.defaultCheckersTheme
}

extension EnvironmentValues {
	var checkersTheme: Theme {
		get {
			self[CheckersThemeKey.self]
		}
		
		set {
			self[CheckersThemeKey.self] = newValue
		}
	}
}

struct CheckersView: View {
	@Environment(\.checkersTheme) private var theme
	@State private var themesSheetShown = false
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
			.background(.linearGradient(colors: [theme.colors[.squareDark], theme.colors[.squareLight]], startPoint: .top, endPoint: .bottom))
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
		.sheet(isPresented: $themesSheetShown) {
			ThemesView(game: .checkers)
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
		.navigationTitle("Checkers")
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
