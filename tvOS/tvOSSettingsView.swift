//
//  SettingsView.swift
//  GradientGamestvOS
//
//  Created by Sam McBroom on 2/15/22.
//
#if os(tvOS)
import SwiftUI
import SwiftData

struct SettingsView: View {
	@Query(sort: \Theme.index) private var themes: [Theme]
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	
	var body: some View {
		Form {
			Section {
				Toggle(isOn: $enableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
				}
				Toggle(isOn: $enableTimer) {
					Label("Timers", systemImage: "clock")
				}
				Toggle(isOn: $showMoves) {
					Label("Show available moves", systemImage: "sparkle.magnifyingglass")
				}
			} header: {
				Text("General")
			} footer: {
				Label("Press the play/pause button to undo.", systemImage: "playpause")
					.symbolVariant(.circle)
			}
			.headerProminence(.increased)
			
			if themes.isEmpty {
				Section("Themes") {
					ContentUnavailableView("Please create themes on your iOS, iPadOS, or macOS device.", systemImage: "paintbrush.pointed", description: Text("Themes will show up here if you are signed into iCloud."))
						.symbolVariant(.fill)
						.frame(maxWidth: .infinity)
						.listRowBackground(Color.clear)
				}
				.headerProminence(.increased)
			}
			
			let chessThemes = themes.filter({ $0.game == .chess })
			if !chessThemes.isEmpty {
				Section("Chess") {
					List {
						ForEach(chessThemes) { theme in
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
				.headerProminence(.increased)
			}
			
			let reversiThemes = themes.filter({ $0.game == .reversi })
			if !reversiThemes.isEmpty {
				Section("Reversi") {
					List {
						ForEach(reversiThemes) { theme in
							let themeSelected = reversiTheme == theme.id.uuidString
							HStack {
								Text(theme.symbol)
								Spacer()
								Button {
									reversiTheme = themeSelected ? "" : theme.id.uuidString
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
				.headerProminence(.increased)
			}
			
			let checkersThemes = themes.filter({ $0.game == .checkers })
			if !checkersThemes.isEmpty {
				Section("Checkers") {
					List {
						ForEach(checkersThemes) { theme in
							let themeSelected = checkersTheme == theme.id.uuidString
							HStack {
								Text(theme.symbol)
								Spacer()
								Button {
									checkersTheme = themeSelected ? "" : theme.id.uuidString
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
				.headerProminence(.increased)
			}
		}
		.navigationTitle("Settings")
	}
}
#endif
