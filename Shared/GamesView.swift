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
		allCases.filter({ detailView in detailView != .settings })
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
	@Query private var reversiBoards: [ReversiBoard]
	@Query private var checkersBoards: [CheckersBoard]
	@State private var selectedView: DetailView?
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.flipUI.rawValue) private var flipped = false
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
	
	private func resetGame(for detailView: DetailView) {
		switch detailView {
		case .chess:
			chessBoards.forEach({ board in context.delete(board) })
			context.insert(ChessBoard())
			return
		case .reversi:
			reversiBoards.forEach({ board in context.delete(board) })
			context.insert(ReversiBoard())
			return
		case .checkers:
			checkersBoards.forEach({ board in context.delete(board) })
			context.insert(CheckersBoard())
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
	
	private func reversiBoard() -> ReversiBoard {
		guard let board = reversiBoards.first else {
			let newBoard = ReversiBoard()
			context.insert(newBoard)
			return newBoard
		}
		return board
	}
	
	private func checkersBoard() -> CheckersBoard {
		guard let board = checkersBoards.first else {
			let newBoard = CheckersBoard()
			context.insert(newBoard)
			return newBoard
		}
		return board
	}
	
//	private func present(_ themeId: UUID) {
//		selectedView = .settings
//		navigation.themeLinkOpened = true
//		path = []
//	}
	
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
				ForEach(DetailView.allGames) { detailView in
					NavigationLink(value: detailView) {
						Label(detailView.title, systemImage: detailView.symbol)
					}
					.contextMenu {
						Button(role: .destructive) {
							resetGame(for: detailView)
						} label: {
							Label("New game", systemImage: "trash")
						}
					}
				}
#if os(tvOS)
				Divider()
				NavigationLink(value: DetailView.settings) {
					Label(DetailView.settings.title, systemImage: DetailView.settings.symbol)
				}
#endif
			}
			.symbolVariant(.fill)
			.foregroundStyle(.primary)
#if os(iOS)
			.toolbar {
				ToolbarItem {
					Button {
						selectedView = .settings
					} label: {
						Label(DetailView.settings.title, systemImage: DetailView.settings.symbol)
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
			switch selectedView {
			case .none:
				ContentUnavailableView("Select a game", systemImage: "circle", description: Text(""))
			case .chess:
				let theme = ChessUITheme(theme: themes.first(where: { $0.id.uuidString == chessTheme }))
				ChessView(board: chessBoard(), enableUndo: enableUndo, flipped: flipped, enableTimer: enableTimer, showMoves: showMoves)
					.environment(\.chessTheme, theme)
			case .reversi:
				let theme = ReversiUITheme(theme: themes.first(where: { $0.id.uuidString == reversiTheme }))
				ReversiView(board: reversiBoard(), enableUndo: enableUndo, flipped: flipped, enableTimer: enableTimer, showMoves: showMoves)
					.environment(\.reversiTheme, theme)
			case .checkers:
				let theme = CheckersUITheme(theme: themes.first(where: { $0.id.uuidString == checkersTheme }))
				CheckersView(board: checkersBoard(), enableUndo: enableUndo, flipped: flipped, enableTimer: enableTimer, showMoves: showMoves)
					.environment(\.checkersTheme, theme)
			case .settings:
				SettingsView()
			}
		}
	}
}
