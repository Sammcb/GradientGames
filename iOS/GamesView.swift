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
}

struct GamesView: View {
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
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

		guard var pieceLightString = queryItems[1].value, var pieceDarkString = queryItems[2].value else {
			return
		}

		guard var squareLightString = queryItems[3].value, var squareDarkString = queryItems[4].value else {
			return
		}

		pieceLightString.removeFirst()
		pieceDarkString.removeFirst()
		squareLightString.removeFirst()
		squareDarkString.removeFirst()

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

		guard var pieceLightString = queryItems[1].value, var pieceDarkString = queryItems[2].value else {
			return
		}

		guard var squareString = queryItems[3].value, var borderString = queryItems[4].value else {
			return
		}

		pieceLightString.removeFirst()
		pieceDarkString.removeFirst()
		squareString.removeFirst()
		borderString.removeFirst()

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
	
	var body: some View {
		NavigationView {
			List {
				NavigationLink(tag: Navigation.ViewId.chess, selection: $navigation.view) {
					ChessView()
						.navigationBarTitleDisplayMode(.inline)
				} label: {
					Label("Chess", systemImage: "crown")
						.contextMenu {
							Button(role: .destructive) {
								ChessState.reset()
							} label: {
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
							Button(role: .destructive) {
								ReversiState.reset()
							} label: {
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
			}
		}
		.navigationViewStyle(.stack)
		.environmentObject(navigation)
	}
}
