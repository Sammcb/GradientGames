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
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\CheckersTheme.index, order: .forward)]) private var checkersThemes: FetchedResults<CheckersTheme>
	@StateObject private var navigation = Navigation()
	
	private func present(_ id: UUID) {
		navigation.sheet = nil
		navigation.view = .settings
		navigation.editing = id
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
		
		present(theme.id!)
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
		
		present(theme.id!)
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
		
		present(theme.id!)
	}
	
	var body: some View {
		NavigationView {
			List {
				NavigationLink(tag: Navigation.ViewId.chess, selection: $navigation.view) {
					ChessView()
						.navigationBarTitleDisplayMode(.inline)
				} label: {
					Label("Chess", systemImage: "crown")
						.contextMenu {
							Button(role: .destructive, action: ChessState.reset) {
								Label("New game", systemImage: "trash")
							}
						}
				}
				NavigationLink(tag: Navigation.ViewId.reversi, selection: $navigation.view) {
					ReversiView()
						.navigationBarTitleDisplayMode(.inline)
				} label: {
					Label("Reversi", systemImage: "circle")
						.contextMenu {
							Button(role: .destructive, action: ReversiState.reset) {
								Label("New game", systemImage: "trash")
							}
						}
				}
				NavigationLink(tag: Navigation.ViewId.checkers, selection: $navigation.view) {
					CheckersView()
						.navigationBarTitleDisplayMode(.inline)
				} label: {
					Label("Checkers", systemImage: "circle")
						.symbolVariant(.circle)
						.contextMenu {
							Button(role: .destructive, action: CheckersState.reset) {
								Label("New game", systemImage: "trash")
							}
						}
				}
			}
			.symbolVariant(.fill)
			.foregroundColor(.primary)
			.toolbar {
				NavigationLink(destination: SettingsView(), tag: Navigation.ViewId.settings, selection: $navigation.view) {
					Label("Settings", systemImage: "gearshape")
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
		}
		.navigationViewStyle(.stack)
		.environmentObject(navigation)
	}
}
