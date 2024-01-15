//
//  GamesView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData

private enum DetailView: String, Identifiable, CaseIterable {
	case chess, reversi, checkers, settings
	
	var id: String {
		rawValue
	}
	
	static var allGames: [Self] {
		allCases.filter({ $0 != .settings })
	}
	
	var title: String {
		rawValue.capitalized
	}
	
	var symbol: String {
		switch self {
		case .chess: "crown"
		case .reversi: "circle"
		case .checkers: "circle.circle"
		case .settings: "gearshape"
		}
	}
}

struct GamesView: View, UniversalLinkReciever {
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@Query private var chessBoards: [ChessBoard]
	@State private var navigation = Navigation()
	@State private var reversiGame = ReversiGame()
	@State private var checkersGame = CheckersGame()
	@State private var path: [UUID] = []
	@State private var selectedView: DetailView?
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.flipUI.rawValue) private var flipped = false
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	
	private func resetGame(for detailView: DetailView) {
		switch detailView {
		case .chess:
			chessBoards.forEach({ board in context.delete(board) })
			context.insert(ChessBoard())
			return
		case .reversi:
			return
		case .checkers:
			return
		case .settings:
			return
		}
	}
	
	private func chessBoard() -> ChessBoard {
		guard let board = chessBoards.first else {
			let newBoard = ChessBoard()
			context.insert(newBoard)
			return newBoard
		}
		return board
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
				ForEach(DetailView.allGames) { detailView in
					NavigationLink(value: detailView) {
						Label(detailView.title, systemImage: detailView.symbol)
							.contextMenu {
								Button(role: .destructive) {
									resetGame(for: detailView)
								} label: {
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
					let theme = ChessUITheme(theme: themes.first(where: { $0.id.uuidString == chessTheme }))
					ChessView(board: chessBoard(), enableUndo: enableUndo, flipped: flipped, enableTimer: enableTimer)
						.environment(\.chessTheme, theme)
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
