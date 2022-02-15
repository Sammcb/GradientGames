//
//  ReversiView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiBoardLengthKey: EnvironmentKey {
	static let defaultValue: CGFloat = .zero
}

struct ReversiThemeKey: EnvironmentKey {
	static let defaultValue = ReversiUITheme()
}

extension EnvironmentValues {
	var reversiBoardLength: Double {
		get {
			self[ReversiBoardLengthKey.self]
		}
		
		set {
			self[ReversiBoardLengthKey.self] = newValue
		}
	}
	
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

struct ReversiPortraitGameView: View {
	var body: some View {
		VStack {
			ReversiPortraitUIView()
#if os(tvOS)
				.focusSection()
#endif
			
			Spacer()
				.frame(maxHeight: .infinity)
			
			HStack {
				ReversiStatsView()
			}
			.frame(maxWidth: .infinity)
			.padding(.top)
			.background(.ultraThinMaterial)
		}
		.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		.frame(maxHeight: .infinity)
	}
}

struct ReversiLandscapeGameView: View {
	var body: some View {
		HStack {
			VStack {
				ReversiStatsView()
			}
			.frame(maxHeight: .infinity)
			.padding(.horizontal)
			.background(.ultraThinMaterial)
			
			Spacer()
				.frame(maxHeight: .infinity)
			
			ReversiLandscapeUIView()
#if os(tvOS)
				.focusSection()
#endif
		}
		.font(.system(.headline, design: .rounded).bold().monospacedDigit())
		.frame(maxHeight: .infinity)
	}
}

struct ReversiView: View {
	@EnvironmentObject private var settings: Settings
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var themes: FetchedResults<ReversiTheme>
	@StateObject private var game = ReversiGame()
	private var theme: ReversiUITheme {
		guard let selectedTheme = themes.first(where: { $0.id! == settings.reversiThemeId }) else {
			return ReversiUITheme()
		}
		return ReversiUITheme(theme: selectedTheme)
	}
	
	var body: some View {
		GeometryReader { geometry in
			let width = geometry.size.width
			let height = geometry.size.height - geometry.safeAreaInsets.bottom
			let size = min(width, height)
			ZStack {
				LinearGradient(colors: [theme.square, theme.border], startPoint: .top, endPoint: .bottom)
					.ignoresSafeArea()
				
				if width < height {
					ReversiPortraitGameView()
				} else {
					ReversiLandscapeGameView()
				}
				
				ReversiBoardView()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.environment(\.reversiBoardLength, size)
		}
#if os(tvOS)
		.onPlayPauseCommand {
			if game.board.history.isEmpty {
				return
			}
			
			game.board.undo()
		}
#endif
		.environment(\.reversiTheme, theme)
		.environmentObject(game)
	}
}
