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
	
	init?(game: Theme.Game) {
		self.init(rawValue: game.rawValue)
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
	
	// TODO: Delete after most users have updated to 2.0.0
	@Query private var oldChessThemes: [ChessTheme]
	@Query private var oldReversiThemes: [ReversiTheme]
	@Query private var oldCheckersThemes: [CheckersTheme]
	
	private func parseTheme(_ url: URL) {
		guard let theme = try? parseUniversalLink(url) else {
			return
		}
		
		let gameThemes = themes.filter({ $0.game == theme.game })
		if let lastThemeIndex = gameThemes.last?.index {
			theme.index = lastThemeIndex + 1
		}
		
		context.insert(theme)
		switch theme.game {
		case .chess: chessTheme = theme.id.uuidString
		case .reversi: reversiTheme = theme.id.uuidString
		case .checkers: checkersTheme = theme.id.uuidString
		}
		selectedView = DetailView(game: theme.game)
	}
	
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
				Section {
					NavigationLink(value: DetailView.settings) {
						Label(DetailView.settings.title, systemImage: DetailView.settings.symbol)
					}
				} header: {
					VStack{
						Divider()
					}
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
				parseTheme(url)
			}
			// TODO: Delete after most users have updated to 2.0.0
			.onChange(of: oldChessThemes.count) {
				guard !oldChessThemes.isEmpty else {
					return
				}
				MigrateOldThemes.migrate(context)
			}
			// TODO: Delete after most users have updated to 2.0.0
			.onChange(of: oldReversiThemes.count) {
				guard !oldReversiThemes.isEmpty else {
					return
				}
				MigrateOldThemes.migrate(context)
			}
			// TODO: Delete after most users have updated to 2.0.0
			.onChange(of: oldCheckersThemes.count) {
				guard !oldCheckersThemes.isEmpty else {
					return
				}
				MigrateOldThemes.migrate(context)
			}
		} detail: {
			switch selectedView {
			case nil:
				ContentUnavailableView("Pick a game to play!", systemImage: "rectangle.checkered")
#if os(tvOS)
					.focusable()
#endif
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			case .chess:
				let theme = themes.first(where: { $0.id.uuidString == chessTheme }) ?? Theme.defaultChessTheme
				ChessView(board: chessBoard(), enableUndo: enableUndo, flipped: flipped, enableTimer: enableTimer, showMoves: showMoves)
					.environment(\.chessTheme, theme)
			case .reversi:
				let theme = themes.first(where: { $0.id.uuidString == reversiTheme }) ?? Theme.defaultReversiTheme
				ReversiView(board: reversiBoard(), enableUndo: enableUndo, flipped: flipped, enableTimer: enableTimer, showMoves: showMoves)
					.environment(\.reversiTheme, theme)
			case .checkers:
				let theme = themes.first(where: { $0.id.uuidString == checkersTheme }) ?? Theme.defaultCheckersTheme
				CheckersView(board: checkersBoard(), enableUndo: enableUndo, flipped: flipped, enableTimer: enableTimer, showMoves: showMoves)
					.environment(\.checkersTheme, theme)
			case .settings:
				SettingsView()
			}
		}
	}
}
