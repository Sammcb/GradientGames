//
//  CheckersView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

import SwiftUI

struct CheckersBoardLengthKey: EnvironmentKey {
	static let defaultValue: CGFloat = .zero
}

struct CheckersThemeKey: EnvironmentKey {
	static let defaultValue = CheckersUITheme()
}

extension EnvironmentValues {
	var checkersBoardLength: Double {
		get {
			self[CheckersBoardLengthKey.self]
		}
		
		set {
			self[CheckersBoardLengthKey.self] = newValue
		}
	}
	
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
	
	init(theme: CheckersTheme) {
		squareLight = Color(theme.squareLight)
		squareDark = Color(theme.squareDark)
		pieceLight = Color(theme.pieceLight)
		pieceDark = Color(theme.pieceDark)
	}
	
	init() {
		squareLight = Color(red: 196 / 255, green: 180 / 255, blue: 151 / 255)
		squareDark = Color(red: 168 / 255, green: 128 / 255, blue: 99 / 255)
		pieceLight = Color(red: 230 / 255, green: 212 / 255, blue: 162 / 255)
		pieceDark = Color(red: 64 / 255, green: 57 / 255, blue: 52 / 255)
	}
}

struct CheckersPortraitGameView: View {
	var body: some View {
		VStack {
			CheckersPortraitUIView()
#if os(tvOS)
				.focusSection()
#endif

			Spacer()
				.frame(maxHeight: .infinity)
		}
		.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		.frame(maxHeight: .infinity)
	}
}

struct CheckersLandscapeGameView: View {
	var body: some View {
		HStack {
			Spacer()
				.frame(maxHeight: .infinity)

			CheckersLandscapeUIView()
#if os(tvOS)
				.focusSection()
#endif
		}
		.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		.frame(maxHeight: .infinity)
	}
}

struct CheckersView: View {
	@EnvironmentObject private var settings: Settings
	@FetchRequest(sortDescriptors: [SortDescriptor(\CheckersTheme.index, order: .forward)]) private var themes: FetchedResults<CheckersTheme>
	@StateObject private var game = CheckersGame()
	private var theme: CheckersUITheme {
		guard let selectedTheme = themes.first(where: { $0.id! == settings.checkersThemeId }) else {
			return CheckersUITheme()
		}
		return CheckersUITheme(theme: selectedTheme)
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
					CheckersPortraitGameView()
				} else {
					CheckersLandscapeGameView()
				}
				
				CheckersBoardView()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.environment(\.checkersBoardLength, size)
		}
#if os(tvOS)
		.onPlayPauseCommand {
//			guard game.pawnSquare == nil else {
//				return
//			}
//
//			if game.board.history.isEmpty {
//				return
//			}
//
//			game.selectedSquare = nil
//			game.board.undo()
		}
#endif
		.environment(\.checkersTheme, theme)
		.environmentObject(game)
	}
}
