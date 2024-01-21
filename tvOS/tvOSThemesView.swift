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
		NavigationStack {
			Form {
				List {
					ForEach(gameThemes) { theme in
						let themeSelected = chessTheme == theme.id.uuidString
						HStack {
							Text(theme.symbol)
							Spacer()
							Button {
								chessTheme = themeSelected ? "" : theme.id.uuidString
							} label: {
								Label("Selected", systemImage: "checkmark.circle.fill")
									.labelStyle(.iconOnly)
									.opacity(themeSelected ? 1 : 0)
									.foregroundStyle(.green)
							}
						}
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
