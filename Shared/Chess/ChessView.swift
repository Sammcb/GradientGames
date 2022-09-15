//
//  ChessView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

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
	
	init(theme: ChessTheme) {
		squareLight = Color(theme.squareLight)
		squareDark = Color(theme.squareDark)
		pieceLight = Color(theme.pieceLight)
		pieceDark = Color(theme.pieceDark)
	}
	
	init() {
		squareLight = Color(red: 192 / 255, green: 192 / 255, blue: 192 / 255)
		squareDark = Color(red: 96 / 255, green: 96 / 255, blue: 96 / 255)
		pieceLight = .white
		pieceDark = .black
	}
}

struct ChessView: View {
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var themes: FetchedResults<ChessTheme>
	@StateObject private var game = ChessGame()
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	private var theme: ChessUITheme {
		guard let selectedTheme = themes.first(where: { $0.id!.uuidString == chessTheme }) else {
			return ChessUITheme()
		}
		return ChessUITheme(theme: selectedTheme)
	}
	
	var body: some View {
		GeometryReader { geometry in
			let vertical = geometry.size.width < geometry.size.height
			let layout = vertical ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
			
			layout {
				ChessUIView(vertical: vertical)
					.animation(.linear, value: game.pawnSquare)
#if os(tvOS)
					.focusSection()
#endif
				ChessBoardView()
					.animation(.linear, value: game.pawnSquare)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				if game.pawnSquare != nil {
					ChessPromoteView(isLight: game.board.lightTurn, vertical: vertical)
				}
			}
			.background(.linearGradient(colors: [theme.squareLight, theme.squareDark], startPoint: .top, endPoint: .bottom))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		}
#if os(iOS)
		.navigationBarTitleDisplayMode(.inline)
#elseif os(tvOS)
		.onPlayPauseCommand {
			guard game.pawnSquare == nil else {
				return
			}
			
			if game.board.history.isEmpty {
				return
			}
			
			game.selectedSquare = nil
			game.board.undo()
		}
#endif
		.environment(\.chessTheme, theme)
		.environmentObject(game)
	}
}
