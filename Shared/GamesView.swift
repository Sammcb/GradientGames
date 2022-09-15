//
//  GamesView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

enum ThemeLink: String {
	case chess = "/ChessColors/"
	case reversi = "/ReversiColors/"
	case checkers = "/CheckersColors/"
}

struct GamesView: View {
	private enum DetailView: String, Identifiable, CaseIterable {
		case chess
		case reversi
		case checkers
		case settings
		
		var id: String {
			rawValue
		}
	}
	
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\CheckersTheme.index, order: .forward)]) private var checkersThemes: FetchedResults<CheckersTheme>
	@StateObject private var navigation = Navigation()
	@State private var path: [UUID] = []
	@State private var selectedView: DetailView?
	
	private func getViewTitle(for id: DetailView) -> String {
		switch id {
		case .chess:
			return "Chess"
		case .reversi:
			return "Reversi"
		case .checkers:
			return "Checkers"
		case .settings:
			return "Settings"
		}
	}
	
	private func getViewSymbol(for id: DetailView) -> String {
		switch id {
		case .chess:
			return "crown"
		case .reversi:
			return "circle"
		case .checkers:
			return "circle.circle"
		case .settings:
			return "gearshape"
		}
	}
	
	private func getGameState(for id: DetailView) -> GameState? {
		switch id {
		case .chess:
			return ChessState.shared
		case .reversi:
			return ReversiState.shared
		case .checkers:
			return CheckersState.shared
		case .settings:
			return nil
		}
	}
	
	private func present(_ theme: Theme) {
		selectedView = .settings
		navigation.themeLinkOpened = true
		path = []
	}
	
	private func parseChessLink(_ queryItems: [URLQueryItem]) {
		guard let symbol = queryItems[0].value else {
			return
		}

		guard let pieceLightString = queryItems[1].value, let pieceDarkString = queryItems[2].value else {
			return
		}

		guard let squareLightString = queryItems[3].value, let squareDarkString = queryItems[4].value else {
			return
		}

		guard let pieceLight = Int64(pieceLightString, radix: 16), let pieceDark = Int64(pieceDarkString, radix: 16) else {
			return
		}

		guard let squareLight = Int64(squareLightString, radix: 16), let squareDark = Int64(squareDarkString, radix: 16) else {
			return
		}
		
		let themeCount = Int(chessThemes.last?.index ?? -1)
		let theme = ChessTheme(context: context)
		theme.id = UUID()
		theme.symbol = symbol
		theme.squareLightRaw = squareLight
		theme.squareDarkRaw = squareDark
		theme.pieceLightRaw = pieceLight
		theme.pieceDarkRaw = pieceDark
		theme.index = Int64(themeCount + 1)
		Store.shared.save()
		
		present(theme)
	}
	
	private func parseReversiLink(_ queryItems: [URLQueryItem]) {
		guard let symbol = queryItems[0].value else {
			return
		}

		guard let pieceLightString = queryItems[1].value, let pieceDarkString = queryItems[2].value else {
			return
		}

		guard let squareString = queryItems[3].value, let borderString = queryItems[4].value else {
			return
		}

		guard let pieceLight = Int64(pieceLightString, radix: 16), let pieceDark = Int64(pieceDarkString, radix: 16) else {
			return
		}

		guard let square = Int64(squareString, radix: 16), let border = Int64(borderString, radix: 16) else {
			return
		}
		
		let themeCount = Int(reversiThemes.last?.index ?? -1)
		let theme = ReversiTheme(context: context)
		theme.id = UUID()
		theme.symbol = symbol
		theme.squareRaw = square
		theme.borderRaw = border
		theme.pieceLightRaw = pieceLight
		theme.pieceDarkRaw = pieceDark
		theme.index = Int64(themeCount + 1)
		Store.shared.save()
		
		present(theme)
	}
	
	private func parseCheckersLink(_ queryItems: [URLQueryItem]) {
		guard let symbol = queryItems[0].value else {
			return
		}

		guard let pieceLightString = queryItems[1].value, let pieceDarkString = queryItems[2].value else {
			return
		}

		guard let squareLightString = queryItems[3].value, let squareDarkString = queryItems[4].value else {
			return
		}

		guard let pieceLight = Int64(pieceLightString, radix: 16), let pieceDark = Int64(pieceDarkString, radix: 16) else {
			return
		}

		guard let squareLight = Int64(squareLightString, radix: 16), let squareDark = Int64(squareDarkString, radix: 16) else {
			return
		}
		
		let themeCount = Int(checkersThemes.last?.index ?? -1)
		let theme = CheckersTheme(context: context)
		theme.id = UUID()
		theme.symbol = symbol
		theme.squareLightRaw = squareLight
		theme.squareDarkRaw = squareDark
		theme.pieceLightRaw = pieceLight
		theme.pieceDarkRaw = pieceDark
		theme.index = Int64(themeCount + 1)
		Store.shared.save()
		
		present(theme)
	}
	
	var body: some View {
		NavigationSplitView {
			List(DetailView.allCases.filter({ $0 != .settings }), selection: $selectedView) { detailView in
				NavigationLink(value: detailView) {
					Label(getViewTitle(for: detailView), systemImage: getViewSymbol(for: detailView))
						.contextMenu {
							Button(role: .destructive, action: getGameState(for: detailView)!.reset) {
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
					Label(getViewTitle(for: .settings), systemImage: getViewSymbol(for: .settings))
				}
			}
			.navigationTitle("Games")
			.onOpenURL { url in
				guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
					return
				}
				
				guard let queryItems = components.queryItems, queryItems.count == 5 else {
					return
				}
				
				if components.path == ThemeLink.chess.rawValue {
					parseChessLink(queryItems)
					return
				}
				
				if components.path == ThemeLink.reversi.rawValue {
					parseReversiLink(queryItems)
					return
				}
				
				if components.path == ThemeLink.checkers.rawValue {
					parseCheckersLink(queryItems)
					return
				}
			}
		} detail: {
			NavigationStack(path: $path) {
				switch selectedView {
				case .none:
					Text("Select a game")
				case .chess:
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
