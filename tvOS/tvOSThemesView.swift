//
//  tvOSThemesView.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/20/24.
//

#if os(tvOS)
import SwiftUI
import SwiftData

struct ThemesView: View {
	@Query(sort: \Theme.index) private var themes: [Theme]
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	let game: Theme.Game
	
	var body: some View {
		let gameThemes = themes.filter({ $0.game == game })
		let gameTheme = switch game {
		case .chess: chessTheme
		case .reversi: reversiTheme
		case .checkers: checkersTheme
		}
		
		NavigationStack {
			Form {
				Section {
					let selectedThemeMissing = !themes.contains(where: { theme in theme.id.uuidString == gameTheme })
					Button {
						switch game {
						case .chess: chessTheme = ""
						case .reversi: reversiTheme = ""
						case .checkers: checkersTheme = ""
						}
					} label: {
						let defaultTheme = switch game {
						case .chess: Theme.defaultChessTheme
						case .reversi: Theme.defaultReversiTheme
						case .checkers: Theme.defaultCheckersTheme
						}
						ThemeListEntryView(theme: defaultTheme, selected: selectedThemeMissing)
					}
					.foregroundStyle(.primary)
				}
				
				List {
					ForEach(gameThemes) { theme in
						let themeSelected = gameTheme == theme.id.uuidString
						Button {
							switch game {
							case .chess: chessTheme = themeSelected ? "" : theme.id.uuidString
							case .reversi: reversiTheme = themeSelected ? "" : theme.id.uuidString
							case .checkers: checkersTheme = themeSelected ? "" : theme.id.uuidString
							}
						} label: {
							ThemeListEntryView(theme: theme, selected: themeSelected)
						}
						.foregroundStyle(.primary)
					}
				}
			}
			.overlay {
				if gameThemes.isEmpty {
					ContentUnavailableView("Please create themes on your iOS, iPadOS, or macOS device.", systemImage: "paintbrush.pointed", description: Text("Themes will show up here if you are signed into iCloud."))
						.symbolVariant(.fill)
				}
			}
			.navigationTitle("Themes")
		}
	}
}
#endif
