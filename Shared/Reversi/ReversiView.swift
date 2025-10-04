//
//  ReversiView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData

extension EnvironmentValues {
	@Entry var reversiTheme: Theme = .defaultReversiTheme
}

struct ReversiView: View {
	@Environment(\.reversiTheme) private var theme
	@Environment(\.verticalUI) private var verticalUI
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	@State private var themesSheetShown = false
	var board: ReversiBoard

	var body: some View {
		let layout = verticalUI ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())

		layout {
			ReversiUIView(board: board)

			ReversiBoardView(board: board)
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
		.animation(.easeIn, value: enableTimer)
		.background(.linearGradient(colors: [theme.colors[.squares], theme.colors[.borders]], startPoint: .top, endPoint: .bottom))
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.font(.system(.headline).monospaced())
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
		.toolbarBackgroundVisibility(.hidden)
		.toolbar {
			ToolbarItemGroup {
				if enableUndo {
					Button(action: board.undo) {
						Image(systemName: "arrow.uturn.backward")
							.symbolVariant(.circle.fill)
							.rotationEffect(board.lightTurn && flipUI ? .radians(.pi) : .zero)
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
