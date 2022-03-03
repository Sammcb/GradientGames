//
//  ChessView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ChessBoardLengthKey: EnvironmentKey {
	static let defaultValue: CGFloat = .zero
}

struct ChessThemeKey: EnvironmentKey {
	static let defaultValue = ChessUITheme()
}

extension EnvironmentValues {
	var chessBoardLength: Double {
		get {
			self[ChessBoardLengthKey.self]
		}
		
		set {
			self[ChessBoardLengthKey.self] = newValue
		}
	}
	
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

struct ChessPortraitGameView: View {
	@EnvironmentObject private var game: ChessGame
	
	var body: some View {
		VStack {
			ChessPortraitUIView()
#if os(tvOS)
				.focusSection()
#endif
			
			Spacer()
				.frame(maxHeight: .infinity)
			
			if game.pawnSquare != nil {
				HStack {
					ChessPromoteView(isLight: game.board.lightTurn)
				}
				.background(.ultraThinMaterial)
#if os(tvOS)
				.focusSection()
#endif
				.transition(.opacity.animation(.linear))
			}
		}
		.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		.frame(maxHeight: .infinity)
	}
}

struct ChessLandscapeGameView: View {
	@EnvironmentObject private var game: ChessGame
	
	var body: some View {
		HStack {
			if game.pawnSquare != nil {
				VStack {
					ChessPromoteView(isLight: game.board.lightTurn)
				}
				.padding(.horizontal)
				.background(.ultraThinMaterial)
#if os(tvOS)
				.focusSection()
#endif
				.transition(.opacity.animation(.linear))
			}
			
			Spacer()
				.frame(maxHeight: .infinity)
			
			ChessLandscapeUIView()
#if os(tvOS)
				.focusSection()
#endif
		}
		.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		.frame(maxHeight: .infinity)
	}
}

struct ChessView: View {
	@EnvironmentObject private var settings: Settings
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var themes: FetchedResults<ChessTheme>
	@StateObject private var game = ChessGame()
	private var theme: ChessUITheme {
		guard let selectedTheme = themes.first(where: { $0.id! == settings.chessThemeId }) else {
			return ChessUITheme()
		}
		return ChessUITheme(theme: selectedTheme)
	}
	
	var body: some View {
		GeometryReader { geometry in
			let width = geometry.size.width
			let height = geometry.size.height - geometry.safeAreaInsets.bottom
			let size = min(width, height)
			ZStack {
				LinearGradient(colors: [theme.squareLight, theme.squareDark], startPoint: .top, endPoint: .bottom)
					.ignoresSafeArea()
				
				if width < height {
					ChessPortraitGameView()
				} else {
					ChessLandscapeGameView()
				}
				
				ChessBoardView()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.environment(\.chessBoardLength, size)
		}
#if os(tvOS)
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
