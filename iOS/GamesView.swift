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
	@StateObject private var navigation = Navigation()
	
	private func present(_ id: Navigation.SheetId) {
		navigation.editingId = nil
		navigation.view = .settings
		navigation.sheet = id
	}
	
	private func parseChessLink(_ queryItems: [URLQueryItem]) {
		guard let symbol = queryItems[0].value else {
			navigation.showAlert = true
			return
		}

		guard var pieceLightString = queryItems[1].value, var pieceDarkString = queryItems[2].value else {
			navigation.showAlert = true
			return
		}

		guard var squareLightString = queryItems[3].value, var squareDarkString = queryItems[4].value else {
			navigation.showAlert = true
			return
		}

		pieceLightString.removeFirst()
		pieceDarkString.removeFirst()
		squareLightString.removeFirst()
		squareDarkString.removeFirst()

		guard let pieceLight = Int64(pieceLightString, radix: 16), let pieceDark = Int64(pieceDarkString, radix: 16) else {
			navigation.showAlert = true
			return
		}

		guard let squareLight = Int64(squareLightString, radix: 16), let squareDark = Int64(squareDarkString, radix: 16) else {
			navigation.showAlert = true
			return
		}
		
		navigation.chessSymbol = symbol
		navigation.chessSquareLight = Color(uiColor: UIColor(hex: squareLight))
		navigation.chessSquareDark = Color(uiColor: UIColor(hex: squareDark))
		navigation.chessPieceLight = Color(uiColor: UIColor(hex: pieceLight))
		navigation.chessPieceDark = Color(uiColor: UIColor(hex: pieceDark))
		
		present(.importChess)
	}
	
	private func parseReversiLink(_ queryItems: [URLQueryItem]) {
		guard let symbol = queryItems[0].value else {
			navigation.showAlert = true
			return
		}

		guard var pieceLightString = queryItems[1].value, var pieceDarkString = queryItems[2].value else {
			navigation.showAlert = true
			return
		}

		guard var squareString = queryItems[3].value, var borderString = queryItems[4].value else {
			navigation.showAlert = true
			return
		}

		pieceLightString.removeFirst()
		pieceDarkString.removeFirst()
		squareString.removeFirst()
		borderString.removeFirst()

		guard let pieceLight = Int64(pieceLightString, radix: 16), let pieceDark = Int64(pieceDarkString, radix: 16) else {
			navigation.showAlert = true
			return
		}

		guard let square = Int64(squareString, radix: 16), let border = Int64(borderString, radix: 16) else {
			navigation.showAlert = true
			return
		}
		
		navigation.reversiSymbol = symbol
		navigation.reversiSquare = Color(uiColor: UIColor(hex: square))
		navigation.reversiBorder = Color(uiColor: UIColor(hex: border))
		navigation.reversiPieceLight = Color(uiColor: UIColor(hex: pieceLight))
		navigation.reversiPieceDark = Color(uiColor: UIColor(hex: pieceDark))

		present(.importReversi)
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
					navigation.showAlert = true
					return
				}
				
				guard let queryItems = components.queryItems, queryItems.count == 5 else {
					navigation.showAlert = true
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
				
				navigation.showAlert = true
			}
			.alert("Failed to import theme", isPresented: $navigation.showAlert) {
				Button("Ok", role: .cancel) {}
			}
			.sheet(item: $navigation.sheet) { sheet in
				if sheet == .importChess {
					ImportChessThemeView()
				} else if sheet == .importReversi {
					ImportReversiThemeView()
				}
			}
		}
		.environmentObject(navigation)
	}
}
