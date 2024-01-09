//
//  GamesView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData

struct GamesView: View, UniversalLinkReciever {
	private enum DetailView: String, Identifiable, CaseIterable {
		case chess
		case reversi
		case checkers
		case settings
		
		var id: String {
			rawValue
		}
	}
	
	private struct ViewInfo {
		let title: String
		let symbol: String
		let game: Game?
	}
	
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@State private var navigation = Navigation()
	@State private var chessGame = ChessGame()
	@State private var reversiGame = ReversiGame()
	@State private var checkersGame = CheckersGame()
	@State private var path: [UUID] = []
	@State private var selectedView: DetailView?
	
	private func getViewInfo(for id: DetailView) -> ViewInfo {
		switch id {
		case .chess:
			return ViewInfo(title: "Chess", symbol: "crown", game: chessGame)
		case .reversi:
			return ViewInfo(title: "Reversi", symbol: "circle", game: reversiGame)
		case .checkers:
			return ViewInfo(title: "Checkers", symbol: "circle.circle", game: checkersGame)
		case .settings:
			return ViewInfo(title: "Settings", symbol: "gearshape", game: nil)
		}
	}
	
	private func present(_ themeId: UUID) {
		selectedView = .settings
		navigation.themeLinkOpened = true
		path = []
	}
	
	private func createTheme(with themeField: ThemeField) {
//		let theme: Theme
//		switch themeField {
//		case .chess(let symbol, let pieceLight, let pieceDark, let squareLight, let squareDark):
//			let lastThemeIndex = chessThemes.last?.index ?? -1
//			let themeIndex = lastThemeIndex + 1
//			let chessTheme = ChessTheme(index: themeIndex, symbol: symbol, pieceDark: pieceDark, pieceLight: pieceLight, squareDark: squareDark, squareLight: squareLight)
//			context.insert(chessTheme)
//		case .reversi(let symbol, let pieceLight, let pieceDark, let square, let border):
//			let lastThemeIndex = reversiThemes.last?.index ?? -1
//			let themeIndex = lastThemeIndex + 1
//			let reversiTheme = ReversiTheme(index: themeIndex, symbol: symbol, pieceDark: pieceDark, pieceLight: pieceLight, border: border, square: square)
//			context.insert(reversiTheme)
//		case .checkers(let symbol, let pieceLight, let pieceDark, let squareLight, let squareDark):
//			let lastThemeIndex = checkersThemes.last?.index ?? -1
//			let themeIndex = lastThemeIndex + 1
//			let checkersTheme = CheckersTheme(index: themeIndex, symbol: symbol, pieceDark: pieceDark, pieceLight: pieceLight, squareDark: squareDark, squareLight: squareLight)
//			context.insert(checkersTheme)
//		}
//		try? context.save()
		
//		present(theme)
	}
	
	var body: some View {
		NavigationSplitView {
			List(selection: $selectedView) {
#if targetEnvironment(macCatalyst)
				Section("Games") {
					ForEach(DetailView.allCases.filter({ $0 != .settings })) { detailView in
						let viewInfo = getViewInfo(for: detailView)
						let action = viewInfo.game?.reset ?? {}
						NavigationLink(value: detailView) {
							Label(viewInfo.title, systemImage: viewInfo.symbol)
								.contextMenu {
									Button(role: .destructive, action: action) {
										Label("New game", systemImage: "trash")
									}
								}
						}
					}
				}
				
				Section("Customization") {
					let detailView: DetailView = .settings
					let viewInfo = getViewInfo(for: detailView)
					NavigationLink(value: detailView) {
						Label(viewInfo.title, systemImage: viewInfo.symbol)
					}
				}
#else
				ForEach(DetailView.allCases.filter({ $0 != .settings })) { detailView in
					NavigationLink(value: detailView) {
						let viewInfo = getViewInfo(for: detailView)
						let action = viewInfo.game?.reset ?? {}
						Label(viewInfo.title, systemImage: viewInfo.symbol)
							.contextMenu {
								Button(role: .destructive, action: action) {
									Label("New game", systemImage: "trash")
								}
							}
					}
				}
#endif
			}
			.symbolVariant(.fill)
			.foregroundStyle(.primary)
#if !targetEnvironment(macCatalyst)
			.toolbar {
				ToolbarItem {
					Button(action: {
						selectedView = .settings
					}) {
						Label("Settings", systemImage: "gearshape")
					}
				}
			}
#endif
			.navigationTitle("Games")
			.onOpenURL { url in
				guard let themeField = try? parseUniversalLink(url) else {
					return
				}
				
				createTheme(with: themeField)
			}
		} detail: {
			NavigationStack(path: $path) {
				switch selectedView {
				case .chess, .none:
					ChessView()
						.environment(chessGame)
				case .reversi:
					ReversiView()
						.environment(reversiGame)
				case .checkers:
					CheckersView()
						.environment (checkersGame)
				case .settings:
					SettingsView()
				}
			}
		}
		.environment(navigation)
	}
}
