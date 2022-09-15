//
//  GamesView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct GamesView: View, UniversalLinkReciever {
	private enum DetailView: String {
		case chess
		case reversi
		case checkers
		case settings
		
		init(_ gameView: GameView) {
			self.init(rawValue: gameView.rawValue)!
		}
	}
	
	private enum GameView: String, Identifiable, CaseIterable {
		case chess
		case reversi
		case checkers
		
		var id: String {
			rawValue
		}
	}
	
	private struct ViewInfo {
		let title: String
		let symbol: String
		let state: GameState
	}
	
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\CheckersTheme.index, order: .forward)]) private var checkersThemes: FetchedResults<CheckersTheme>
	@StateObject private var navigation = Navigation()
	@State private var path: [UUID] = []
	@State private var selectedView: DetailView?
	
	private func getViewInfo(for id: GameView) -> ViewInfo {
		switch id {
		case .chess:
			return ViewInfo(title: "Chess", symbol: "crown", state: ChessState.shared)
		case .reversi:
			return ViewInfo(title: "Reversi", symbol: "circle", state: ReversiState.shared)
		case .checkers:
			return ViewInfo(title: "Checkers", symbol: "circle.circle", state: CheckersState.shared)
		}
	}
	
	private func present(_ theme: Theme) {
		selectedView = .settings
		navigation.themeLinkOpened = true
		path = []
	}
	
	private func createTheme(with themeField: ThemeField) {
		let theme: Theme
		let themes: [Theme]
		switch themeField {
		case .chess(let symbol, let pieceLight, let pieceDark, let squareLight, let squareDark):
			themes = Array(chessThemes)
			let chessTheme = ChessTheme(context: context)
			chessTheme.symbol = symbol
			chessTheme.pieceLightRaw = pieceLight
			chessTheme.pieceDarkRaw = pieceDark
			chessTheme.squareLightRaw = squareLight
			chessTheme.squareDarkRaw = squareDark
			theme = chessTheme
		case .reversi(let symbol, let pieceLight, let pieceDark, let square, let border):
			themes = Array(reversiThemes)
			let reversiTheme = ReversiTheme(context: context)
			reversiTheme.symbol = symbol
			reversiTheme.pieceLightRaw = pieceLight
			reversiTheme.pieceDarkRaw = pieceDark
			reversiTheme.squareRaw = square
			reversiTheme.borderRaw = border
			theme = reversiTheme
		case .checkers(let symbol, let pieceLight, let pieceDark, let squareLight, let squareDark):
			themes = Array(checkersThemes)
			let checkersTheme = CheckersTheme(context: context)
			checkersTheme.symbol = symbol
			checkersTheme.pieceLightRaw = pieceLight
			checkersTheme.pieceDarkRaw = pieceDark
			checkersTheme.squareLightRaw = squareLight
			checkersTheme.squareDarkRaw = squareDark
			theme = checkersTheme
		}
		
		theme.id = UUID()
		let lastThemeIndex = themes.last?.index ?? -1
		theme.index = lastThemeIndex + 1
		Store.shared.save()
		
		present(theme)
	}
	
	var body: some View {
		NavigationSplitView {
			List(GameView.allCases, selection: $selectedView) { gameView in
				NavigationLink(value: DetailView(gameView)) {
					let viewInfo = getViewInfo(for: gameView)
					Label(viewInfo.title, systemImage: viewInfo.symbol)
						.contextMenu {
							Button(role: .destructive, action: viewInfo.state.reset) {
								Label("New game", systemImage: "trash")
							}
						}
				}
			}
			.symbolVariant(.fill)
			.foregroundColor(.primary)
			.toolbar {
				Button(action: {
					selectedView = .settings
				}) {
					Label("Settings", systemImage: "gearshape")
				}
			}
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
				case .reversi:
					ReversiView()
				case .checkers:
					CheckersView()
				case .settings:
					SettingsView()
				}
			}
		}
		.environmentObject(navigation)
	}
}
