//
//  ChessView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData

extension EnvironmentValues {
	@Entry var chessTheme: Theme = .defaultChessTheme
}

struct ChessView: View {
	@Environment(\.chessTheme) private var theme
	@State private var themesSheetShown = false
	var board: ChessBoard
	var enableUndo: Bool
	var flipped: Bool
	var enableTimer: Bool
	var showMoves: Bool
	
	var body: some View {
		GeometryReader { geometry in
			let vertical = geometry.size.width < geometry.size.height
			let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
			
			layout {
				ChessUIView(board: board, enableTimer: enableTimer, flipped: flipped, vertical: vertical)
				
				if board.promoting {
					ChessPromoteView(board: board, flipped: flipped, vertical: vertical)
						.transition(.opacity.animation(.easeIn))
				}
				
				ChessBoardView(board: board, flipped: flipped, showMoves: showMoves)
					.animation(.easeInOut(duration: 0.6), value: board.promoting)
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
			board.selectedSquare = nil
			board.times.lastUpdate = Date()
		}
		.onDisappear {
			board.selectedSquare = nil
		}
		.sheet(isPresented: $themesSheetShown) {
			ThemesView(game: .chess)
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
		.navigationTitle("Chess")
		.toolbar {
			ToolbarItemGroup {
				if enableUndo {
					Button(action: board.undo) {
						Image(systemName: "arrow.uturn.backward")
							.symbolVariant(.circle.fill)
							.rotationEffect(!board.lightTurn && flipped ? .radians(.pi) : .zero)
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
